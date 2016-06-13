/**
 * @file Beep Module
 * @summary Play a beep on the client system.
 * @author IMcPwn 
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

electron = require('electron');

electron.shell.beep();
ws.send("Beep played");
