/**
 # Cordova Plugin Speech Recognition for iOS.
   Add the voice recognition function to the application using the Siri API.

   Target OS Version : iOS(ver 10.0 or Higher)
 
   copyright (C) 2016 SOHKAKUDO Ltd. All Rights Reserved.
 */
@objc(CDVSpeechRecognition) class SpeechRecognition : CDVPlugin, TimeOutDelegate {

    private var srvc : CDVSpeechRecognitionViewController = CDVSpeechRecognitionViewController()
    private var enabled: Bool = false
    private var appView = UIWebView()
    
    private var thisCommand: CDVInvokedUrlCommand = CDVInvokedUrlCommand()
    
    override func pluginInitialize() {
        super.pluginInitialize()
        srvc = CDVSpeechRecognitionViewController()
        srvc.delegate = self
        appView = super.webView as! UIWebView
    }

    /** SpeechRecognizer Start/Stop Handler. */
    func recordButtonTapped(_ command: CDVInvokedUrlCommand) {
        thisCommand = command
        if(srvc.isEnabled()) {
            let recognitionLimitSec = command.argument(at: 0)
            if(recognitionLimitSec is String == false) {
                returnResult(statusIsOK: false, returnString: "commandArgIsNotString")
                return
            }

            if let second = NumberFormatter().number(from: recognitionLimitSec as! String){
                srvc.setRecognitionLimitSec(v: Int(second))
            } else {
                returnResult(statusIsOK: false, returnString: "recognitionLimitSecTypeInvalid")
                return
            }
             
            let returnString: String = srvc.recordButtonTapped()
            if(returnString != "recognizeNow") {
                returnResult(statusIsOK: true, returnString: returnString)
            }
        }else{
            returnResult(statusIsOK: false, returnString: "pluginIsDisabled")
        }
    }

    /** SpeechRecognizer time up Handler. */
    func timeOut() {
        returnResult(statusIsOK: false, returnString: "timeOut")
    }
    
    /** returns the result to the calling app. */
    func returnResult(statusIsOK: Bool, returnString: String) -> Void {
        let sendStatus = statusIsOK ? CDVCommandStatus_OK : CDVCommandStatus_ERROR
        let result = CDVPluginResult(status: sendStatus, messageAs: returnString)
        commandDelegate.send(result, callbackId:thisCommand.callbackId)
    }
}
