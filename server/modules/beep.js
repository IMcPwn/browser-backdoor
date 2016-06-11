/*
 * Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Plays the system beep.
 * Parameters: None
 * Returns: undefined
 * Author: IMcPwn
 */

electron = require('electron');

return electron.shell.beep();
