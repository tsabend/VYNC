//
//  File.swift
//  VYNC
//
//  Created by Thomas Abend on 1/18/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//
import UIKit
import CoreMedia
import CoreData
import MobileCoreServices
import AVKit
import AVFoundation

//let standin = "https://s3-us-west-2.amazonaws.com/telephono/IMG_0370.MOV"
let path = NSBundle.mainBundle().pathForResource("IMG_0370", ofType:"MOV")
let standin = NSURL.fileURLWithPath(path!) as NSURL!
let docFolderToSaveFiles = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
let fileName = "/videoToSend.MOV"
let PathToFile = docFolderToSaveFiles + fileName


class VyncListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var vyncTable: UITableView!
    let camera = VyncCamera()
    var refreshControl:UIRefreshControl!
    
    var vyncs = [
        ["title": "Crazy vync", "length": "4", "new": "false"],
        ["title": "Wild vync", "length": "1", "new": "false"],
        ["title": "vyncMi", "length": "2", "new": "true"],
        ["title": "Look at this amazing couch!", "length": "4", "new": "false"],
        ["title": "Backfliiiiip", "length": "4", "new": "true"],
        ["title": "guess who?", "length": "6", "new": "false"],
        ["title": "vyncMe", "length": "4", "new": "true"]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        camera.delegate = self
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "showCam")
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "showCam")
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "reloadVyncs", forControlEvents: UIControlEvents.ValueChanged)
        self.vyncTable.addSubview(refreshControl)
        
        vyncTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vyncs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VyncCell", forIndexPath: indexPath) as VyncCell
//        Listen for long touch
        let longTouch = UILongPressGestureRecognizer()
        longTouch.addTarget(self, action: "holdToPlayVideos:")
        cell.addGestureRecognizer(longTouch)
//        Set Title
        cell.lengthLabel.text = vyncs[indexPath.row]["length"]
        cell.statusLogo.textColor = UIColor(netHex:0x7FF2FF)
        cell.subTitle.text = "January 14 - Hold to Play"
        // New vyncs
        if vyncs[indexPath.row]["new"] == "true" {
            cell.statusLogo.textColor = UIColor(netHex:0xFFB5C9)
            cell.subTitle.text = "January 14 - Swipe to Reply"
            let pan = UIPanGestureRecognizer(target: self, action: "reply:")
            cell.addGestureRecognizer(pan)
        }
        cell.titleLabel.text = vyncs[indexPath.row]["title"]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentCell = vyncTable.cellForRowAtIndexPath(indexPath) as VyncCell
        currentCell.selectCellAnimation()
        currentCell.deselectCellAnimation()
    }

    
    @IBAction func holdToPlayVideos(sender: UIGestureRecognizer) {
        if sender.state == .Began {
            println("Playing Videos")
            let playerLayer = videoPlayer([standin])
            playerLayer.player.play()
            self.view.layer.addSublayer(playerLayer)
        }
        if sender.state == .Ended {
            println("Dismissing PlayerLayer")
            if let avView : AVPlayerLayer = self.view.layer.sublayers.last as AVPlayerLayer! {
                avView.removeFromSuperlayer()
            }
            self.navigationController?.navigationBar.hidden = false
            UIApplication.sharedApplication().statusBarHidden=false
        }
    }

    @IBAction func reply(sender:UIPanGestureRecognizer){
        if sender.state == .Ended {
            println("reply")
            showCam()
        }
    }
    
    @IBAction func showCam() {
        println("showing Camera")
        UIApplication.sharedApplication().statusBarHidden=true
        self.presentViewController(camera, animated: false, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        println("and out")
        //save the video that the user records
        let fileUrl = info[UIImagePickerControllerMediaURL] as? NSURL
        var myVideo : NSData = NSData(contentsOfURL: fileUrl!)!
        var boolean = myVideo.writeToFile(PathToFile, atomically: true)
        let playerLayer = videoPlayer([fileUrl!])
        
        let pickingOverlay = PickingOverlay.loadFromNib() as PickingOverlay!
        pickingOverlay.playerLayer = playerLayer
        playerLayer.player.play()
        picker.view.layer.addSublayer(playerLayer)
        picker.view.addSubview(pickingOverlay)
    }

    @IBAction func reloadVyncs() {
        //            imagePickerControllerDidCancel()
        self.refreshControl.beginRefreshing()
        println("reloading Vyncs")
        self.refreshControl.endRefreshing()
    }
}



//let button   = UIButton()
//button.frame = CGRectMake(140, 500, 80, 80)
//button.backgroundColor = UIColor.redColor()
//button.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "record:"))


//        self.vyncTable.backgroundColor = UIColor.greenColor()

//            let avPlayerVC = VyncPlayer()
//            avPlayerVC.player = player
//            avPlayerVC.showsPlaybackControls = false
//
//
//            self.presentViewController(avPlayerVC, animated: false, completion: {
//                avPlayerVC.player.play()
//                })
//            var newView = UIView(frame: self.view.bounds)
//            newView.backgroundColor=UIColor.redColor()
//            newView.tag = 10