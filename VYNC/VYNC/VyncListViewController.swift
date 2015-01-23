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

//
//class VyncCell: UITableViewCell {
//    @IBOutlet var backgroundImage: UIImageView
//    @IBOutlet var titleLabel: UILabel
//}

//let standin = "https://s3-us-west-2.amazonaws.com/telephono/IMG_0370.MOV"
let path = NSBundle.mainBundle().pathForResource("IMG_0370", ofType:"MOV")
let standin = NSURL.fileURLWithPath(path!) as NSURL!

class VyncListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var vyncTable: UITableView!
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
        // Do any additional setup after loading the view, typically from a nib.

        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "showCam")
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "onSwipe")
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "reloadVyncs", forControlEvents: UIControlEvents.ValueChanged)
        self.vyncTable.addSubview(refreshControl)
        
        self.vyncTable.rowHeight = 50
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
// font size/type, padd text and image, hold to play video, animate single click event, open vid player on hold event, logo at the top, use different font and color for the navigation bar
        
        let cell = tableView.dequeueReusableCellWithIdentifier("VyncCell", forIndexPath: indexPath) as VyncCell
//        Listen for long touch
        let longTouch = UILongPressGestureRecognizer()
        longTouch.addTarget(self, action: "longPressed:")
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
    
    @IBAction func longPressed(sender: UIGestureRecognizer) {
        if sender.state == .Began {
            println("Received longPress!")
            var urlsToPlay = createAVItems([standin])
            let player = AVQueuePlayer(items: urlsToPlay)// NSURL(string: url)
            let layer = AVPlayerLayer(player: player)

            self.navigationController?.navigationBar.hidden = true
            UIApplication.sharedApplication().statusBarHidden=true
            var bounds = self.view.frame
            //            bounds.offset(dx: CGFloat(0), dy: CGFloat(64))
            bounds.size.height += 60
            bounds.origin.y -= 60
            
            println("bounds: \(bounds)")
            layer.bounds = bounds
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill
            layer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
            layer.player.play()
            self.view.layer.addSublayer(layer)
        }
        if sender.state == .Ended {
            println("later")
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
        println("sup! in showcam")
        let imagePicker = UIImagePickerController() //inst
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera // Set the media type to allow movies
        imagePicker.mediaTypes = [kUTTypeMovie] // Maximum length 6 seconds
        imagePicker.videoMaximumDuration = 6.00
        imagePicker.showsCameraControls = false

        

        
        let overlay = UIView()
        
        let button   = UIButton()
        button.frame = CGRectMake(245, 0, 78, 78)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("VYNC", forState: UIControlState.Normal)
        button.titleLabel!.font =  UIFont(name: "Helvetica", size: 20)
        button.addTarget(self, action: "flipCamera", forControlEvents: UIControlEvents.TouchUpInside)
        overlay.addSubview(button)
        
        
        // flip button
        let flipImage = UIImage(contentsOfFile: "camera-rotate")
        let flipButton = UIButton()
        flipButton.setImage(flipImage, forState: UIControlState.Normal)
        var flipFrame = CGRectMake(30,30,100,100)
        flipButton.frame = flipFrame

        flipButton.addTarget(self, action: "flipCamera:", forControlEvents: UIControlEvents.TouchUpInside)
        flipButton.frame = flipFrame
        
        overlay.addSubview(flipButton)

        imagePicker.cameraOverlayView = overlay
        
        self.presentViewController(imagePicker, animated: false, completion:{
            let backToVyncView = UIScreenEdgePanGestureRecognizer(target: self, action: "dismissCamera:")
            backToVyncView.edges = UIRectEdge.Left
            imagePicker.view.addGestureRecognizer(backToVyncView)
            
            
            
        })
        
    }
    

    @IBAction func dismissCamera(sender:UIScreenEdgePanGestureRecognizer) {
        if sender.state == .Ended {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        
    }
    
    @IBAction func flipCamera() {
        //            imagePickerControllerDidCancel()
        println("hey flip")//
        UIAlertView(title: "flip", message: "am i working", delegate: nil, cancelButtonTitle: "ok").show()
        
    }

    
    @IBAction func reloadVyncs() {
        //            imagePickerControllerDidCancel()
        self.refreshControl.beginRefreshing()
        println("reloading Vyncs")
        self.refreshControl.endRefreshing()
    }
}


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