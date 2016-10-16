/*

    Cordova Plugin Speech Recognition feat. Siri API
    https://github.com/bluedesign/speech-recognition-feat-siri

    by SOHKAKUDO Ltd.
    MIT License

*/

var exec = require('cordova/exec');

var SpeechRecognition = {
  recordButtonTapped: function(limitationSec, onSuccess, onFail) {
    exec(onSuccess, onFail, 'SpeechRecognition', 'recordButtonTapped', [limitationSec]);
  }
};
module.exports = SpeechRecognition