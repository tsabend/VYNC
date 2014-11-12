//
//  ViewController.swift
//  Chainer
//
//  Created by Apprentice on 11/9/14.
//  Copyright (c) 2014 DBC. All rights reserved.
//

import UIKit
import CoreMedia
import CoreData
import MobileCoreServices
import AVKit

let s3Url = "https://s3-us-west-2.amazonaws.com/telephono/"
let docFolderToSaveFiles = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
let fileName = "/videoToSend.MOV"
let PathToFile = docFolderToSaveFiles + fileName

public let sampleVideoPath =
NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("/sample_iTunes.mov")

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblChains: UITableView!

    var chains = [[VideoMessage]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "showCam")
        self.navigationItem.rightBarButtonItem = rightBarButtonItem

    }
    
    // Load the table view
    
    // Returning to view. Loops through users and reloads them.
    override func viewWillAppear(animated: Bool) {
        chains = videoMessageMgr.asChains()
        tblChains.reloadData()
        super.viewWillAppear(animated)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.textLabel.text = "Chain in reply to: \(chains[indexPath.row].first!.replyToID)"
        cell.detailTextLabel?.text = "Length: \(chains[indexPath.row].count)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chains.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            println("delete")
        }
    }
    
    // Load the camera on top
    
    @IBAction func showCam() {
        let imagePicker = UIImagePickerController() //inst
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera // Set the media type to allow movies
        imagePicker.mediaTypes = [kUTTypeMovie] // Maximum length 6 seconds
        imagePicker.videoMaximumDuration = 5.00
        self.presentViewController(imagePicker, animated: false, completion:{})
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        picker.dismissViewControllerAnimated(false, completion: {})
        
        //save the video that the user records
        let fileUrl = info[UIImagePickerControllerMediaURL] as? NSURL
        var myVideo : NSData = NSData(contentsOfURL: fileUrl!)!
        var boolean = myVideo.writeToFile(PathToFile, atomically: true)
        println("Save to file was successful: \(boolean)")
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Contacts") as ContactsViewController
        self.presentViewController(vc, animated:false, completion:{})
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if chains[indexPath.row].last?.recipientID == userID {
            // display only the most recent video in chain
            let url = [s3Url + chains[indexPath.row].first!.videoID]
            playVidUrlOnViewController(url, self)
        } else {
            // display the whole the chain
            println("loop through the whole chain")
            let urls = map(chains[indexPath.row], { s3Url + $0.videoID})
            println("\(urls)")
        }
    }
}

