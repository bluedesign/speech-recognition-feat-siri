# cordova-plugin-speech-recognition-feat-siri

This plugin provides access to Speech Recognition API(Apple SFSpeechRecognizer).

<a href="https://developer.apple.com/library/content/samplecode/SpeakToMe/Introduction/Intro.html">Build&amp;Runtime Requirements</a>

It is not available until after the `deviceready` event.


This plugin does not provide a graphical user interface.<br />
We are not planning to provide it in the future.<br />
Because it is a plug-in of Apache Cordoba which is a hybrid application.<br />
We believe that our plugin should not restrict the design of your application.<br />
Please implement sophisticated GUI designed for application.<br />
<br />
We'll introduce an iOS application installed without modifying our plugin.<br />
Please check it<br />

<a href='https://itunes.apple.com/jp/app/knot/id1138536144?mt=8' target='blank'>KNot(SOHKAKUDO Ltd.)</a>


## Installation

    cordova plugin add cordova-plugin-speech-recognition-feat-siri


### iOS Quirks

Since iOS 10 it's mandatory to add a `NSMicrophoneUsageDescription` and `NSSpeechRecognitionUsageDescription` in the info.plist.

- `NSMicrophoneUsageDescription` describes the reason that the app accesses the user’s Microphone.
- `NSSpeechRecognitionUsageDescription` Specifies the reason for your app to send user data to Apple’s speech recognition servers. 

## Xcode Project Setting(in 2016, Xcode8)

Please in the set include the swift module at the time of release build generation.


Setting position: Xcode project > TARGETS > Build Setting > Linking > Runpath Search Paths > Release

Setting value: @executable_path/Frameworks


## Usage

### Methods

- `SpeechRecognition.recordButtonTapped`

#### SpeechRecognition.recordButtonTapped

The tap of the toggle button on the UI indicates the start and stop of the speech recognition.

   
    SpeechRecognition.recordButtonTapped([LimitationSeconds], onSuccess, onError)


- __LimitationSeconds__:  Limitation seconds of Speech Recognition . _(String)_

- __onSuccess__: Call back when the API call to the voice recognition was successful. _(Function)_

- __onError__: Call back when the API call of speech recognition has failed. _(Function)_

#### Return Value

#####on Success(returnMessage) : 

There are three ways to obtain the result of speech recognition (2 and 3 are new functions).

1. Your application calls the plug-in method twice at the timing of start and end of speech recognition.

    1. The voice input between the first and the second call will be converted as into character type and will be returned to the caller.

    2. Therefore, at the time of the first method call, it is just waiting for voice input.<br />
    Because the plug-in does not control the user interface, please implement the user interface of speech recognition state in the app side.

    3. At method call the second time, it returns of analyzing the result of speech recognition as a character type.


2. After the sound input by the microphone, when a certain period of time elapses with no voice, the speech recognition is automatically ended and the text is returned to the caller.


3. When the upper limit of the speech recognition time(LimitationSeconds) specified by the method is exceeded, the speech recognition is automatically ended and the text is returned to the caller



#####on Error(errorMessage) : 

These error string is returned from the plug-in.

|return value(type: string)|description|
|:--|:--|
|"commandArgIsNotString"|Invalid argument. specify the character type in the argument "limitationSeconds".|
|"recognitionLimitSecTypeInvalid"|Invalid argument. specify the character type that can be interpreted as a numerical value to the argument "limitationSeconds".|
|"timeOut"|Interrupted the speech recognition. Because it exceeds the upper limit(argument "limitationSeconds") of the specified time.|
|"pluginIsDisabled"|Plug-ins can not be used for any reason.|


#### Example

    function doSpeechRecognition() {
	    if(SpeechRecognition) {
           SpeechRecognition.recordButtonTapped(
               '15',  // ex. 15 seconds limitation for Speech
               function(returnMessage){
                   console.log(returnMessage); // onSuccess
               },
               function(errorMessage) {
                   console.log(errorMessage); // onError
               }
           )
        }
    };


## Supported Platforms

- iOS 

## Development and verification environment

1. Xcode : 8.2.1(8C1002, swift compiler uses the latest version included in Xcode)
2. Node.js : v6.9.2
3. npm : 4.0.5
4. Apache Cordova : 6.4.0
5. cordova ios : 4.3.1


## LICENSE ##

Copyright (c) 2016-2017 SOHKAKUDO Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---

### Includes Sample Code "SpeakToMe" License

Sample code project: SpeakToMe: Using Speech Recognition with AVAudioEngine
Version: 1.0 

<a href='https://developer.apple.com/library/content/samplecode/SpeakToMe/Introduction/Intro.html' target='blank'>Guides and Sample Code</a>

IMPORTANT:  This Apple software is supplied to you by Apple
Inc. ("Apple") in consideration of your agreement to the following
terms, and your use, installation, modification or redistribution of
this Apple software constitutes acceptance of these terms.  If you do
not agree with these terms, please do not use, install, modify or
redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and
subject to these terms, Apple grants you a personal, non-exclusive
license, under Apple's copyrights in this original Apple software (the
"Apple Software"), to use, reproduce, modify and redistribute the Apple
Software, with or without modifications, in source and/or binary forms;
provided that if you redistribute the Apple Software in its entirety and
without modifications, you must retain this notice and the following
text and disclaimers in all such redistributions of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may
be used to endorse or promote products derived from the Apple Software
without specific prior written permission from Apple.  Except as
expressly stated in this notice, no other rights or licenses, express or
implied, are granted by Apple herein, including but not limited to any
patent rights that may be infringed by your derivative works or by other
works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2016 Apple Inc. All Rights Reserved.
