#
# Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
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
                abort(@@configfile['priv_key'] + " does not exist.")
            elsif !File.exist?(@@configfile['cert_chain'])
                abort(@@configfile['cert_chain'] + " does not exist.")
            end
        end
    end
    
    def Config.loadLog
        if @@configfile == nil
            abort("Config has not been loaded. loadConfig() must be called first.")
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

