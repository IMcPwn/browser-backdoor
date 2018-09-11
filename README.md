BrowserBackdoor [![Build Status](https://travis-ci.org/IMcPwn/browser-backdoor.svg?branch=master)](https://travis-ci.org/IMcPwn/browser-backdoor) [![Code Climate](https://codeclimate.com/github/IMcPwn/browser-backdoor/badges/gpa.svg)](https://codeclimate.com/github/IMcPwn/browser-backdoor) [![License](https://img.shields.io/badge/license-MIT-orange.svg)](https://github.com/IMcPwn/browser-backdoor/blob/master/LICENSE)
===================

 [![Screenshots](https://github.com/IMcPwn/browser-backdoor/wiki/images/BbsConsole.png)](https://github.com/IMcPwn/browser-backdoor/wiki/Screenshots)

BrowserBackdoor is an [Electron](https://github.com/electron/electron) application that uses a JavaScript WebSocket Backdoor to connect to the listener.

BrowserBackdoorServer is a [WebSocket](https://en.wikipedia.org/wiki/WebSocket) server that listens for incoming WebSocket connections
and creates a command-line interface for sending commands to the remote system.

The JavaScript backdoor in BrowserBackdoor can be used on all browsers that support WebSockets.
It will not have access to the Electron API of the host computer unless the BrowserBackdoor Client application is used.

Some things you can do if you have access to the Electron API:

1. [Open new browser windows that can point to any website.](http://electron.atom.io/docs/api/shell/#shellopenexternalurl-options) (already built-in. See: [server/modules/openURL.js](https://github.com/IMcPwn/browser-backdoor/blob/master/server/modules/openURL.js)).

2. [Change and read the clipboard.](http://electron.atom.io/docs/api/clipboard/#clipboard) (already built-in. See: [server/modules/readClipboard.js](https://github.com/IMcPwn/browser-backdoor/blob/master/server/modules/readClipboard.js) and [server/modules/writeClipboard.js](https://github.com/IMcPwn/browser-backdoor/blob/master/server/modules/writeClipboard.js)).

3. [Access cross-platform Operating System notifications and the tray on OS X and Windows.](http://electron.atom.io/docs/api/tray/#tray)

4. [Take screenshots.](http://electron.atom.io/docs/api/desktop-capturer/#desktopcapturer) (already built-in. See: [server/modules/screenshot.js](https://github.com/IMcPwn/browser-backdoor/blob/master/server/modules/screenshot.js)).

5. [Execute arbitrary system commands.](http://stackoverflow.com/a/28394895) (already built-in. See: [server/modules/execCmd.js](https://github.com/IMcPwn/browser-backdoor/blob/master/server/modules/execCmd.js))

6. [Run at startup.](https://www.npmjs.com/package/auto-launch) (already built-in. See: [client/main.js](https://github.com/IMcPwn/browser-backdoor/blob/master/client/main.js) and [server/modules/manageStartup.js](https://github.com/IMcPwn/browser-backdoor/blob/master/server/modules/manageStartup.js)).

Support
===================

If you find an issue with the program please use the issue tracker: https://github.com/IMcPwn/browser-backdoor/issues

Wiki
===================
Screenshots are avaliable on the Wiki!
https://github.com/IMcPwn/browser-backdoor/wiki/Screenshots

More information will be added to it soon.

Usage
===================
The client application will run in the background and provide no user interface while running.
To check that it's running, quit it, or enable/disable system startup press Command (OS X) OR Control (Windows/Linux) + Alt + \ or whatever you configured the shortcut as in client/main.js.

The server application's usage can be accessed by typing help in the command line.

Installing
===================

Requirements for client:
- Latest Node.js and npm

Requirements for server:
- Ruby 2.1+ and the gems in the Gemfile

BrowserBackdoor Client is supported on all devices supported by Electron.
Currently that is [Windows 32/64, OS X 64, and Linux 32/64](https://github.com/electron-userland/electron-packager#supported-platforms).

BrowserBackdoorServer has been tested on Ubuntu 14.04, Debian 8, and Kali Linux.
It should work on any similar Linux operating system.

To install anything, first, clone the repository. All the rest of the commands shown assume you are in the root of the repository.

```sh
git clone https://github.com/IMcPwn/browser-backdoor
cd browser-backdoor
```

How to install and run the BrowserBackdoor client application:

```sh
cd client
npm install
#
# Configure index.html and main.js before the next command.
#
npm start
```

How to build client executables (see [here](https://github.com/electron-userland/electron-packager) for more information):
```sh
cd client
npm install electron-packager -g
electron-packager . --all
```

How to run BrowserBackdoorServer:

```sh
cd server
gem install bundler
bundle install
#
# Configure config.yml before the next command
#
ruby bbsconsole.rb
```

License
===================
MIT

Disclaimer
===================
This is a personal development project, please do not use it for nefarious purposes.
The author bears no responsibility for any misuse of the program.

Contact
===================
This program is made by Carleton Stuberg.

Contact information such as email, twitter, and other methods of contact are avaliable here: https://imcpwn.com
