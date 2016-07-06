/**
 * @file forceQuit Module
 * @summary Forcefully shuts down the client.
 * @author IMcPwn 
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

ws.send("Process halting");
process.exit(0);
