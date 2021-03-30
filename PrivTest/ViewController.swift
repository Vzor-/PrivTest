//
//  ViewController.swift
//  PrivTest
//
//  Created by Kyle Berezin on 3/25/21.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
    var recorder:AVAudioRecorder!
    private var destinationUrl: URL!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func startRecording(_ sender: Any) {
        record()
    }
    func record () {
        let paths = FileManager.default.urls(for: .musicDirectory,
                                             in: .userDomainMask)
        let documentsDirectory = URL(fileURLWithPath: NSTemporaryDirectory())

        let currentTime = Int(Date().timeIntervalSince1970 * 1000)

        let outputURL = URL(fileURLWithPath: "SpeechRecorder-\(currentTime).wav",
          relativeTo: documentsDirectory)

        destinationUrl = outputURL
        NSLog("Location \(destinationUrl)")
        do {
        let format = AVAudioFormat(settings: [
          AVFormatIDKey: kAudioFormatLinearPCM,
          AVEncoderAudioQualityKey: AVAudioQuality.high,
          AVSampleRateKey: 44100.0,
          AVNumberOfChannelsKey: 1,
          AVLinearPCMBitDepthKey: 16,
          ])!
        
        recorder = try AVAudioRecorder(url: destinationUrl, format: format)
        recorder.record()
        
        } catch let error {
            NSLog("error: \(error)")
        }
        //var session:AVAudioSession.sharedInstance();
    }
    func prompt(){
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized: // The user has previously granted
            record()

        case .notDetermined: // The user has not yet been asked
          AVCaptureDevice.requestAccess(for: .audio) { granted in

            if granted {
                self.record()
            }
          }

        case .denied: // The user has previously denied access.
          ()

        case .restricted: // The user can't grant access due to restrictions.
          ()
        }
    }
    @IBAction func stopRecording(_ sender: Any) {
        recorder.stop()
    }
    @IBOutlet weak var ok: NSScrollView!
    @IBAction func shell(_ sender: Any) {
        
        func shell(_ command: [String]) -> String {
            let task = Process()
            let pipe = Pipe()
            
            task.standardOutput = pipe
            task.standardError = pipe
            task.arguments = command
            task.launchPath = "/bin/zsh"
            task.launch()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)!
            
            return output
        }
        
        let documentsDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        ok.documentView!.insertText(shell(["-c", "ls " + documentsDirectory.path]))
    }
    @IBAction func badls(_ sender: Any) {
        func shell(_ command: [String]) -> String {
            let task = Process()
            let pipe = Pipe()
            
            task.standardOutput = pipe
            task.standardError = pipe
            task.arguments = command
            task.launchPath = "/bin/zsh"
            task.launch()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)!
            
            return output
        }
        
        let documentsDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        ok.documentView!.insertText(shell(["-c", "ls ~/Desktop"]))
    }
    @IBAction func badCommand(_ sender: Any){
        func shell(_ command: [String]) -> String {
            let task = Process()
            let pipe = Pipe()
            
            task.standardOutput = pipe
            task.standardError = pipe
            task.arguments = command
            task.launchPath = "/bin/zsh"
            task.launch()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)!
            
            return output
        }
        
        let documentsDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        ok.documentView!.insertText(shell(["-c", "whoami"]))
        
    }
}
