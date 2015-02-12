//
//  VyncCameraViewController.swift
//  VYNC
//
//  Created by Thomas Abend on 1/27/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class VyncCameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate, VyncCameraPlaybackLayerDelegate {
    
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice!
    var selfieCaptureDevice : AVCaptureDevice!
    var audioCaptureDevice : AVCaptureDevice!
    var previewLayer : AVCaptureVideoPreviewLayer!
    var captureMovieFileOutput: AVCaptureMovieFileOutput? = nil;
    var videoConnection : AVCaptureConnection!
    
    var vync : Vync!
    
    @IBOutlet weak var flashButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCamera()
        
        let backToVyncView = UIScreenEdgePanGestureRecognizer(target: self, action: "dismissCamera:")
        backToVyncView.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(backToVyncView)
        
        if captureDevice != nil {
            beginSession()
        }
    }
    
    func setupCamera(){
        let devices = AVCaptureDevice.devices()
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if device.hasMediaType(AVMediaTypeVideo) {
                // Finally check the position and confirm we've got the back camera
                if device.position == AVCaptureDevicePosition.Back  {
                    captureDevice = device as? AVCaptureDevice
                }
                if device.position == AVCaptureDevicePosition.Front {
                    selfieCaptureDevice = device as? AVCaptureDevice
                }
            }
            else if device.hasMediaType(AVMediaTypeAudio){
                audioCaptureDevice = device as? AVCaptureDevice
            }
        }
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        captureMovieFileOutput = AVCaptureMovieFileOutput()
        captureMovieFileOutput?.maxRecordedDuration = CMTimeMakeWithSeconds(6, 600)
        captureSession.addOutput(captureMovieFileOutput)
        videoConnection = captureMovieFileOutput?.connectionWithMediaType(AVMediaTypeVideo)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func autoFlash(sender: AnyObject) {
        // Set only the torch since flash is for still photos
        if captureDevice.torchAvailable {
            if captureDevice.torchMode.hashValue == 0 {
                captureDevice.lockForConfiguration(nil)
                captureDevice.torchMode = AVCaptureTorchMode.Auto
                flashButton.setTitle("off", forState: .Normal)
                captureDevice.unlockForConfiguration()
            } else {
                captureDevice.lockForConfiguration(nil)
                captureDevice.torchMode = AVCaptureTorchMode.Off
                flashButton.setTitle("flash", forState: .Normal)
                captureDevice.unlockForConfiguration()
            }
        }
    }
    
    @IBAction func flipCamera(sender: AnyObject) {
        println("flipping camera")
        captureSession.beginConfiguration()
        if let currentCamera = captureSession.inputs.first as? AVCaptureDeviceInput {
            if currentCamera.device.position == AVCaptureDevicePosition.Back {
                captureSession.removeInput(captureSession.inputs.first as! AVCaptureInput)
                captureSession.addInput(AVCaptureDeviceInput(device: selfieCaptureDevice, error: nil))
                flashButton.hidden = true
            } else {
                captureSession.removeInput(captureSession.inputs.first as! AVCaptureInput)
                captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: nil))
                flashButton.hidden = false
            }
        }
        captureSession.commitConfiguration()
    }
    
    
    
    func captureOutput(captureOutput: AVCaptureFileOutput!,
        didStartRecordingToOutputFileAtURL fileURL: NSURL!,
        fromConnections connections: [AnyObject]!) {
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!,
        didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!,
        fromConnections connections: [AnyObject]!,
        error: NSError!) {
            println("playing back video")
            let playerLayerView = VyncCameraPlaybackLayer.loadFromNib() as! VyncCameraPlaybackLayer
            playerLayerView.videoList = [outputFileURL, outputFileURL]
            playerLayerView.playbackDelegate = self
            playerLayerView.playVideos()
            self.view.addSubview(playerLayerView)
    }
    
    @IBAction func startRecording(sender: AnyObject) {
        println("startRecording")
        let fileUrl = NSURL.fileURLWithPath(pathToFile) as NSURL!
        captureMovieFileOutput!.startRecordingToOutputFileURL(fileUrl, recordingDelegate: self)
        self.recordButton.setTitle("Recording", forState: .Normal)
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        println("endRecording")
        self.recordButton.setTitle("RECORD", forState: .Normal)
        captureMovieFileOutput?.stopRecording()
    }
    
    @IBAction func dismissCamera(sender:UIScreenEdgePanGestureRecognizer) {
        if sender.state == .Ended {
            println("dismissing camera")
            self.dismissViewControllerAnimated(false, completion:{finished in
                UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)})
        }
    }
    
    
    func beginSession() {
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        captureSession.addInput(AVCaptureDeviceInput(device: audioCaptureDevice, error: &err))
        let tap = UITapGestureRecognizer(target:self, action:"onTap:")
        self.view.addGestureRecognizer(tap)
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer?.frame = UIScreen.mainScreen().bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.insertSublayer(previewLayer, atIndex: 0)
        captureSession.startRunning()
    }
    
    
    func onTap (tap: UITapGestureRecognizer){
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusPointOfInterest = tap.locationInView(self.view)
            device.exposurePointOfInterest = tap.locationInView(self.view)
            device.unlockForConfiguration()
        }
    }
    // Playback Delegate Methods
    func retakeVideo(view:VyncCameraPlaybackLayer) {
        view.removeFromSuperview()
    }
    
    func acceptVideo(view:VyncCameraPlaybackLayer) {
        view.removeFromSuperview()
        if (self.vync != nil) {
            println("reply")
            let contactsNav = self.storyboard?.instantiateViewControllerWithIdentifier("ContactsNav") as! UINavigationController
            let contacts = contactsNav.viewControllers[0] as! ContactsViewController
            // TODO: replace this code with the actual replyToID that has been passed around
            contacts.replyToId = vync.replyToId()
            self.presentViewController(contactsNav, animated: false, completion: nil)
        } else {
            println("first")
            let title = self.storyboard?.instantiateViewControllerWithIdentifier("TitleNav") as! UINavigationController
            self.presentViewController(title, animated: false, completion: nil)
        }
    }
    
    
}

