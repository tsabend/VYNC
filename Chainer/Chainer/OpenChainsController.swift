//
//  OpenChainsController.swift
//  Storyboards
//
//  Created by Apprentice on 11/9/14.
//  Copyright (c) 2014 Apprentice. All rights reserved.
//
import UIKit

class OpenChainsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblvideos: UITableView!
    
    
    override func viewDidLoad() {
        println(videoMessageMgr.openChains.count)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        tblvideos.reloadData()
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
        cell.textLabel.text = "Video Id: \(videoMessageMgr.openChains[indexPath.row].videos.count)"
        cell.detailTextLabel?.text = "VideoChain"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoMessageMgr.openChains.count
    }
    
    // Load a new view when clicked --> to be filled in with a show video route
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("anyone listening?")

    }
}

