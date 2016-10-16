/*
    Copyright (C) 2016 SOHKAKUDO Ltd. All Rights Reserved.
    See LICENSE.txt for this Plugin’s licensing information
*/
/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The primary view controller. The speach-to-text engine is managed an configured here.
*/

import UIKit
import Speech

protocol TimeOutDelegate {
    func timeOut()
}

public class CDVSpeechRecognitionViewController: UIViewController, SFSpeechRecognizerDelegate {

    // MARK: Properties
    
    /** [API Reference] https://developer.apple.com/reference/speech/sfspeechrecognizer
     The Locale setting is based on setting of iOS. 
     */
    private let speechRecognizer = SFSpeechRecognizer()!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    private var recognizedText = ""
    
    private var recognitionLimiter: Timer?
    
    private var recognitionLimitSec: Int = 60
    
    private var status: String = ""
    
    internal var delegate: TimeOutDelegate?
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    func setup() {
        speechRecognizer.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                    case .authorized:
                        self.status = "authorized"
                    case .denied:
                        self.status = "denied"
                    case .restricted:
                        self.status = "restricted"
                    case .notDetermined:
                        self.status = "notDetermined"
                }
            }
        }
    }
    
    /**
     Set Recognition time limitation.
     - parameter v: Specifies the amount of time that the upper limit (in seconds)
     */
    public func setRecognitionLimitSec(v : Int) -> Void {
        self.recognitionLimitSec = v;
    }

    /**
     Plugin Status.
     - return This Plugin's Status: true -> Plugin is Enable, false -> Plugin is Disabled.  
     */
    public func isEnabled() -> Bool {
        return self.status == "authorized"
    }

    private func startRecording() throws {

        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false

            if let result = result {
                self.recognizedText =  result.bestTranscription.formattedString
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
    }

    // MARK: SFSpeechRecognizerDelegate
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
        } else {
        }
    }

    // MARK: Interface Builder actions
    
    public func recordButtonTapped() -> String {
        var ret = ""
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            ret = self.recognizedText
            self.stopTimer()
        } else {
            self.recognizedText = ""
            try! startRecording()
            self.startTimer()
            ret = "recognizeNow"
        }
        return ret
    }
    
    func startTimer() {
        recognitionLimiter = nil
        recognitionLimiter = Timer.scheduledTimer(timeInterval: TimeInterval(self.recognitionLimitSec), 
                            target: self, 
                            selector:#selector(InterruptEvent), 
                            userInfo: nil, 
                            repeats: false
                            )
    } 
    
    func InterruptEvent() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
        recognitionLimiter = nil
        delegate?.timeOut()
    }
    
    func stopTimer() {
        if recognitionLimiter != nil {
            recognitionLimiter?.invalidate(); recognitionLimiter = nil
        }
    }
}
