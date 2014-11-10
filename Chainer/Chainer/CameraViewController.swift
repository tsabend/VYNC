//
//  CameraViewController.swift
//  viewAllUsers
//
//  Created by Apprentice on 11/9/14.
//  Copyright (c) 2014 Apprentice. All rights reserved.
//

import UIKit
import Foundation
import CoreMedia
//import MediaPlayer
import MobileCoreServices

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imagePicker = UIImagePickerController() //inst
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera // Set the media type to allow movies
        imagePicker.mediaTypes = [kUTTypeMovie] // Maximum length 6 seconds
        imagePicker.videoMaximumDuration = 5.00
        self.presentViewController(imagePicker, animated: false, completion: {})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        println("does this get called?")
        let contactsView = self.storyboard?.instantiateViewControllerWithIdentifier("Contacts") as ContactsViewController
        self.navigationController?.pushViewController(contactsView, animated: true)
    }
    
}


//
//let fileUrl = info[UIImagePickerControllerMediaURL] as? NSURL
//
//var request = HTTPTask()
//request.POST("http://chainer.herokuapp.com/upload", parameters:  ["param": "hi", "something": "else", "key": "value","file": HTTPUpload(fileUrl: fileUrl!)], success: {(response: HTTPResponse) in
//    //do stuff
//    },failure: {(error: NSError, response: HTTPResponse?) in
//        //error out on stuff
//})
//var myVideo : NSData = NSData(contentsOfURL: fileUrl!)!
////        let boolean = myVideo.writeToFile(PathToFile, atomically: true)
////
//println("DID IT SUCCEED?")
////        println("\(boolean)")
//
//picker.dismissViewControllerAnimated(true, completion: nil)