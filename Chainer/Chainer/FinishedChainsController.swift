//
//  ViewController.swift
//  Storyboards
//
//  Created by Apprentice on 11/9/14.
//  Copyright (c) 2014 Apprentice. All rights reserved.
//

import UIKit

class FinishedChainsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblVideoMessages: UITableView!
    
    
    override func viewDidLoad() {
        println(videoMessageMgr.finishedVideoMessages.count)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        tblVideoMessages.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITableViewDataSource requirements
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.textLabel.text = "Video Id: \(videoMessageMgr.finishedVideoMessages[indexPath.row].messageID)"
        cell.detailTextLabel?.text = "Reply To: \(videoMessageMgr.finishedVideoMessages[indexPath.row].replyToID). Created at \(videoMessageMgr.finishedVideoMessages[indexPath.row].createdAt)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoMessageMgr.finishedVideoMessages.count
    }
    
    // Load a new view when clicked --> to be filled in with a show video route
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("anyone listening?")
        let cameraView = self.storyboard?.instantiateViewControllerWithIdentifier("Camera") as CameraViewController
        self.navigationController?.pushViewController(cameraView, animated: true)
    }
}

