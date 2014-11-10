//
//  ViewController.swift
//  Chainer
//
//  Created by Apprentice on 11/9/14.
//  Copyright (c) 2014 DBC. All rights reserved.
//

import UIKit
import CoreMedia
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        println("hello")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showCam(sender: AnyObject) {
        let imagePicker = UIImagePickerController() //inst
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera // Set the media type to allow movies
        imagePicker.mediaTypes = [kUTTypeMovie] // Maximum length 6 seconds
        imagePicker.videoMaximumDuration = 5.00
        self.presentViewController(imagePicker, animated: false, completion:{})
    }
}

