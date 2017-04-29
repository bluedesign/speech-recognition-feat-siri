/*

    Cordova Plugin Speech Recognition feat. Siri API
    https://github.com/bluedesign/speech-recognition-feat-siri

    by SOHKAKUDO Ltd.
    MIT License

*/

var exec = require('cordova/exec');

var SpeechRecognitionFeatSiri = {
  recordButtonTapped: function(limitationSec, locale, onSuccess, onFail) {
    if(arguments.callee.length == arguments.length) {
        limitationSec = limitationSec == null? "0" : limitationSec;
        locale = locale == null? "no_locale" : locale;
        exec(onSuccess, onFail, 'SpeechRecognitionFeatSiri', 'recordButtonTapped', [limitationSec, locale]);
    }else{
        alert('[cordova-plugin-speech-recognition-feat-siri] wrong number of arguments (' +
              arguments.length + ' for ' +
              arguments.callee.length + ')');
    }
  }
};
module.exports = SpeechRecognitionFeatSiri