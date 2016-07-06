#
# Copyright (c) 2016 IMcPwn  - http://imcpwn.com
# BrowserBackdoorServer by IMcPwn.
# See the file 'LICENSE' for copying permission
#

require_relative 'printcolor'
require 'logger'

module Bbs

module Config
    @@configfile = nil
    @@log = nil
    
    def Config.loadConfig
        @@configfile = YAML.load_file("config.yml")
        if @@configfile['secure']
            if !File.exist?(@@configfile['priv_key'])
                abort("Fatal error: Private key (#{@@configfile['priv_key']}) does not exist but is configured in config.yml.")
            elsif !File.exist?(@@configfile['cert_chain'])
                abort("Fatal error: Certificate chain (#{@@configfile['cert_chain']}) does not exist but is configured in config.yml.")
            end
        end
        if !File.exist?(@@configfile['out_location'])
            begin
                Dir.mkdir(@@configfile['out_location'])
            rescue => e
                abort("Fatal error: Output folder (#{@@configfile['out_location']}) cannot be created because of error: #{e.message}")
            end
        end
    end
    
    def Config.loadLog
        if @@configfile == nil
            abort("Fatal error: Config has not been loaded. Config.loadConfig() must be called before Config.loadLog().")
        else
            @@log = Logger.new(@@configfile['log'])
        end
    end
    
    def Config.getConfig
        return @@configfile
    end
    
    def Config.getLog
        return @@log
    end
end

end

