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
                Bbs::PrintColor.print_error(@@configfile['priv_key'] + " does not exist.")
                exit
            elsif !File.exist?(@@configfile['cert_chain'])
                Bbs::PrintColor.print_error(@@configfile['cert_chain'] + " does not exist.")
                exit
            end
        end
    end
    
    def Config.loadLog
        if @@configfile == nil
            Bbs::PrintColor.print_error("Config has not been loaded. Try loadConfig() first")
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

