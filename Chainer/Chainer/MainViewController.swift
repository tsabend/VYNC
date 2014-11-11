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

let docFolderToSaveFiles = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
let fileName = "/videoToSend.MOV"
let PathToFile = docFolderToSaveFiles + fileName

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblChains: UITableView!
    var chains : [[VideoMessage]] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "showCam")
        self.navigationItem.rightBarButtonItem = rightBarButtonItem

    }
    
    // Load the table view
    
    // Returning to view. Loops through users and reloads them.
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // I want all the videos nested into chains. Data structure: array of arrays OR Array of Reply_to_ids
        // SELECT reply_to_id FROM videomessage ORDER BY CREATED_AT, REPLY_TO_ID
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"VideoMessage")
        let ed = NSEntityDescription.entityForName("VideoMessage",
            inManagedObjectContext: managedContext)!
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.propertiesToFetch = ["replyToID"]
        //3
        var error: NSError?

        
        let fetchedResults: [AnyObject]? = managedContext.executeFetchRequest(fetchRequest, error: &error)
        if let results = fetchedResults as? [VideoMessage] {
            chains = [[VideoMessage]]()
            var chain = [VideoMessage]()
            for video in results {
                if chain.isEmpty || chain.last!.replyToID == video.replyToID {
                    chain.append(video)
                } else {
                    chains.append(chain)
                    chain = [video]
                }
            }
            if chain.isEmpty == false {
                chains.append(chain)
            }

        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        
        
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
        myVideo.writeToFile(PathToFile, atomically: true)
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Contacts") as ContactsViewController
        self.presentViewController(vc, animated:false, completion:{})
    }
    
    
    
}

