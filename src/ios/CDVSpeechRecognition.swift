/**
 # Cordova Plugin Speech Recognition for iOS.
   Add the voice recognition function to the application using the Siri API.

   Target OS Version : iOS(ver 10.0 or Higher)
 
   copyright (C) 2016 - 2017 SOHKAKUDO Ltd. All Rights Reserved.
 */
@objc(CDVSpeechRecognition) class SpeechRecognition : CDVPlugin, TimeOutDelegate, OnFinalDelegate {

    fileprivate var srvc : CDVSpeechRecognitionViewController = CDVSpeechRecognitionViewController()
    fileprivate var enabled: Bool = false    
    fileprivate var thisCommand: CDVInvokedUrlCommand = CDVInvokedUrlCommand()
    fileprivate var supportedLocaleIdentifiers = Set<String>()
    
    override func pluginInitialize() {
        super.pluginInitialize()
        srvc = CDVSpeechRecognitionViewController()
        srvc.delegate = self
        supportedLocaleIdentifiers = Set<String>()
        srvc.supportedLocales().enumerated().forEach {
            supportedLocaleIdentifiers.insert($0.element.identifier)
        }
    }

    /** SpeechRecognizer Start/Stop Handler. */
    func recordButtonTapped(_ command: CDVInvokedUrlCommand) {
        thisCommand = command
        if(srvc.isEnabled()) {
            let recognitionLimitSec = command.argument(at: 0)
            if(recognitionLimitSec is String == false) {
                returnResult(false, returnString: "commandArg(recognitionLimitSec)IsNotString")
                return
            }
            if let second = NumberFormatter().number(from: recognitionLimitSec as! String){
                srvc.setRecognitionLimitSec(Int(second))
            } else {
                returnResult(false, returnString: "recognitionLimitSecTypeInvalid")
                return
            }

            let locale: Any = command.argument(at: 1) as! String
            if(locale is String == false) {
                returnResult(false, returnString: "commandArg(locale)IsNotString")
                return
            }
            var targetLocale: String = locale as! String
            targetLocale = targetLocale.isEmpty ? self.currentLocaleIdentifer() : targetLocale
            if !supportedLocaleIdentifiers.contains(targetLocale) {
                returnResult(false, returnString: "commandArg(localeIdentifier)Invalid")
                return
            }
             
            let returnString: String = srvc.recordButtonTapped(targetLocale)
            if(returnString != "recognizeNow") {
                returnResult(true, returnString: returnString)
            }
        }else{
            returnResult(false, returnString: "pluginIsDisabled")
        }
    }

    /** SpeechRecognizer time up Handler. */
    func timeOut(_ ret: String) {
        if(ret != "") {
            returnResult(true, returnString: ret)
        } else {
            returnResult(false, returnString: "timeOut")
        }
    }
    
    func onFinal(_ ret: String) {
        returnResult(true, returnString: ret)
    }

    /** returns the result to the calling app. */
    func returnResult(_ statusIsOK: Bool, returnString: String) -> Void {
        let sendStatus = statusIsOK ? CDVCommandStatus_OK : CDVCommandStatus_ERROR
        let result = CDVPluginResult(status: sendStatus, messageAs: returnString)
        commandDelegate.send(result, callbackId:thisCommand.callbackId)
    }

    /**
     get system locale identifer.
     - return systen locale identifer (ex. "ja-JP", "en-US"...)
    */
    func currentLocaleIdentifer() -> String {
        return NSLocale.current.identifier.replacingOccurrences(of: "_", with: "-")
    }
}
