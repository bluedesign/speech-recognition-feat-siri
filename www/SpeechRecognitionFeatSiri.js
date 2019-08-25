/*

    Cordova Plugin Speech Recognition feat. Siri API
    https://github.com/bluedesign/speech-recognition-feat-siri

    by Masakatsu Aoyama.
    MIT License

*/

var exec = require('cordova/exec');

var SpeechRecognitionFeatSiri = {};

SpeechRecognitionFeatSiri.recordButtonTapped = function(_limitationSec, _locale, onSuccess, onFail) {
  if(arguments.callee.length == arguments.length) {
      var limitationSec = _limitationSec == null? "0" : _limitationSec;
      var locale = _locale == null? "no_locale" : _locale;
      exec(onSuccess, onFail, 'SpeechRecognitionFeatSiri', 'recordButtonTapped', [ limitationSec, locale]);
  }else{
      alert('[cordova-plugin-speech-recognition-feat-siri] wrong number of arguments (' +
            arguments.length + ' for ' +
            arguments.callee.length + ')');
  };
};

module.exports = SpeechRecognitionFeatSiri;