#
# Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
# BrowserBackdoorServer by IMcPwn.
# See the file 'LICENSE' for copying permission
#

require 'colorize'

module Bbs

module PrintColor
    def PrintColor.print_error(message)
        puts "[X] ".colorize(:red) + message
    end

    def PrintColor.print_notice(message)
        puts "[*] ".colorize(:green) + message
    end
end

end

