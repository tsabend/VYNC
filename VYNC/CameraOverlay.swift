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

class VyncCamera:UIImagePickerController {
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
        cameraOverlay.camera = self

//        cameraOverlay.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(cameraOverlay)
        println(self.view.subviews)
    }
    



    @IBAction func dismissCamera(sender:UIScreenEdgePanGestureRecognizer) {
        if sender.state == .Ended {
            println("dismissing camera")
            removePickingOverlayFromImagePickerView()
            self.dismissViewControllerAnimated(false, completion:nil)
        }
    }
    
    func removePickingOverlayFromImagePickerView(){
        for view in self.view.subviews {
            println(view)
            if let pickingOverlay = view as? PickingOverlay {
                pickingOverlay.retake()
            }
        }
    }

}

class CameraOverlay: UIView {
    var camera : VyncCamera?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        frame = UIScreen.mainScreen().bounds
        backgroundColor = UIColor.clearColor()
    }
    

    @IBAction func flipCamera(sender: AnyObject) {
        println("flipping camera")
        if camera?.cameraDevice == UIImagePickerControllerCameraDevice.Rear{
            camera?.cameraDevice = UIImagePickerControllerCameraDevice.Front
        } else {
            camera?.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        }
    }
    
    @IBAction func flash(sender: AnyObject) {
            println("set flash")
    }
    
    @IBAction func startRecord(sender: AnyObject) {
        println("begin recording")
        camera?.startVideoCapture()
    }
    
    @IBAction func endRecord(sender: AnyObject) {
        println("end recording")
        camera?.stopVideoCapture()
        
    }


}
