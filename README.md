BrowserBackdoor [![Build Status](https://travis-ci.org/IMcPwn/browser-backdoor.svg?branch=master)](https://travis-ci.org/IMcPwn/browser-backdoor) [![Code Climate](https://codeclimate.com/github/IMcPwn/browser-backdoor/badges/gpa.svg)](https://codeclimate.com/github/IMcPwn/browser-backdoor)
===================
BrowserBackdoor is an electron application that uses a simple JavaScript backdoor to connect to the listener.


BrowserBackdoorServer is a WebSocket server that listens for connections from BrowserBackdoor
and creates an command line interface for executing commands on the remote system(s).

The JavaScript backdoor in BrowserBackdoor can be used on all browsers that support WebSockets.
It will not have access to the Electron API of the host computer unless the BrowserBackdoor Client application is used.

Some things you can do if you have access to the Electron API:

1. [Open new browser windows that can point to any website.]
(https://github.com/electron/electron/blob/master/docs/api/browser-window.md#new-browserwindowoptions)

2. [Change and view the clipboard.]
(https://github.com/electron/electron/blob/master/docs/api/clipboard.md#clipboard)

3. [Access cross-platform Operating System notifications and the tray on OS X and Windows.]
(https://github.com/electron/electron/blob/master/docs/api/tray.md#tray)

4. [Take screenshots.]
(https://github.com/electron/electron-api-demos)

5. [Execute arbitrary system commands.]
(http://stackoverflow.com/a/28394895)

6. [Run at startup.](https://www.npmjs.com/package/auto-launch) (already built-in. See: [client/main.js](https://github.com/IMcPwn/browser-backdoor/blob/master/client/main.js)).

Installing
===================

NodeJS and NPM are required for the client.

Ruby 2.1+ is required for the server.

First, clone the repository. All the rest of the commands shown assume you are in the root of the repository.

```sh
git clone https://github.com/IMcPwn/browser-backdoor
cd browser-backdoor
```

How to install and run the BrowserBackdoor electron application.

```sh
cd client
npm install
# Configure index.html and main.js before the next command
npm start
```

Building executables for all platforms. (see [here](https://github.com/electron-userland/electron-packager) for more information)
```sh
cd client
npm install electron-packager -g
electron-packager . --all
```

How to install and run the BrowserBackdoorServer.
```sh
cd server
gem install bundler
bundle install
# Configure config.yml before the next command
ruby bb-server.rb
```

Usage
===================
The client application will run in the background and provide no user interface while running. 
To check that it's running, quit it, or enable/disable system startup press Command (OS X) OR Control (Windows/Linux) + Alt + \ or whatever you configured the shortcut as in main.js.

The server application's usage can be accessed by typing help in the command line.

License
===================
MIT


Contact
===================
This program is made by IMcPwn .

Contact information such as email, twitter, and other methods of contact are avaliable here: http://imcpwn.com
