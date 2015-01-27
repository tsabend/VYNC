//
//  CameraOverlay.swift
//  VYNC
//
//  Created by Thomas Abend on 1/23/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//


import UIKit
import CoreMedia
import CoreData
import MobileCoreServices
import AVKit
import AVFoundation


protocol CameraOverlayDelegate {
    func flipCamera()
    func toggleFlash(button:UIButton)
    func startRecording()
    func stopRecording()
}



class VyncCamera:UIImagePickerController, CameraOverlayDelegate, PickingOverlayDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sourceType = UIImagePickerControllerSourceType.Camera // Set the media type to allow movies
        self.mediaTypes = [kUTTypeMovie] // Maximum length 6 seconds
        self.videoMaximumDuration = 6.00
        self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        self.showsCameraControls = false
        self.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
        
        let backToVyncView = UIScreenEdgePanGestureRecognizer(target: self, action: "dismissCamera:")
        backToVyncView.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(backToVyncView)
        
//
        let cameraOverlay = CameraOverlay.loadFromNib() as CameraOverlay!
        cameraOverlay.delegate = self

//        cameraOverlay.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(cameraOverlay)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func dismissCamera(sender:UIScreenEdgePanGestureRecognizer) {
        if sender.state == .Ended {
            println("dismissing camera")
            removePickingOverlayFromImagePickerView()
            self.dismissViewControllerAnimated(false, completion:{finished in
                UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)})
        }
    }
    
    func removePickingOverlayFromImagePickerView(){
        for view in self.view.subviews {
            if let pickingOverlay = view as? PickingOverlay {
                pickingOverlay.remove()
            }
        }
    }
    
    // PickingOverlayDelegate methods
    func transitionToTitle(){
        println("transitioning")
        delegate?.imagePickerControllerDidCancel!(self)
    }
    
    // CameraOverlayDelegate methods
    func flipCamera() {
        if self.cameraDevice == UIImagePickerControllerCameraDevice.Rear{
            self.cameraDevice = UIImagePickerControllerCameraDevice.Front
        } else {
            self.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        }
    }
    
    func toggleFlash(button:UIButton){
        let currentFlash = self.cameraFlashMode.hashValue
        if currentFlash == 0 {
            self.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Auto
            button.setImage(UIImage(named: "envelope"), forState: .Normal)
        } else {
            self.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
            button.setImage(UIImage(named: "vynclogo"), forState: .Normal)
        }
    }

    func startRecording() {
        self.startVideoCapture()
    }
    
    func stopRecording() {
        self.stopVideoCapture()
    }
}

class CameraOverlay: UIView {
    var delegate:CameraOverlayDelegate! = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        frame = UIScreen.mainScreen().bounds
        backgroundColor = UIColor.clearColor()
    }

    @IBAction func flipCamera(sender: AnyObject) {
        delegate!.flipCamera()
    }
    
    @IBAction func flash(sender: AnyObject) {
        delegate!.toggleFlash(sender as UIButton)
    }
    
    @IBAction func startRecord(sender: AnyObject) {
        delegate!.startRecording()
    }
    
    @IBAction func endRecord(sender: AnyObject) {
        delegate!.stopRecording()
    }

}
