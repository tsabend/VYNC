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

class VyncListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    @IBOutlet var vyncTable: UITableView!
    var refreshControl:UIRefreshControl!
    
//    Setting this equal to a global variable that is an array of vyncs. This will later be replaced by a function return from a dB query.
    var vyncs = VideoMessage.asVyncs()
    var videoPlayer : QueueLoopVideoPlayer?
    var lastPlayed : Int? = nil

    @IBOutlet weak var showStatsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the font of nav bar title
        let color = UIColor(netHex:0x73A1FF)
        let font = [NSFontAttributeName: UIFont(name: "Egypt 22", size: 50)!, NSForegroundColorAttributeName: color]
        self.navigationController!.navigationBar.titleTextAttributes = font
       // Set the font of nav bar item
        let buttonColor = UIColor(netHex:0x7FF2FF)
        let buttonFont = [NSFontAttributeName: UIFont(name: "flaticon", size: 28)!, NSForegroundColorAttributeName: buttonColor]
        showStatsButton.setTitleTextAttributes(buttonFont, forState: .Normal)
        showStatsButton.title = "\u{e005}"

        // Add pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "reloadVyncs", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.layer.zPosition = -1
        self.vyncTable.addSubview(refreshControl)
        self.vyncTable.rowHeight = 70
        vyncTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vyncs.count
    }
    
    @IBAction func reloadVyncs() {
        self.refreshControl.beginRefreshing()
        VideoMessage.syncer.sync() {done in
            VideoMessage.saveNewVids() {done in
                self.updateView()
                self.refreshControl.endRefreshing()
            }
        }
        User.syncer.sync()

    }
    
    func updateView() {
        self.vyncs = VideoMessage.asVyncs()
        self.vyncTable.reloadData()
        self.vyncTable.setNeedsDisplay()
    }
    
    // Set the properties of cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VyncCell", forIndexPath: indexPath) as VyncCell
        addGesturesToCell(cell)
       //        Set Title and Length Labels
        let date = vyncs[indexPath.row].mostRecent()
        
        cell.titleLabel.text = vyncs[indexPath.row].title()
        cell.lengthLabel.text = String(vyncs[indexPath.row].size())
        // New vyncs get special color and gesture
        if vyncs[indexPath.row].waitingOnYou {
            cell.statusLogo.textColor = UIColor(netHex:0xFFB5C9)
            cell.lengthLabel.text = "?"
            cell.lengthLabel.backgroundColor = UIColor(netHex:0xFFB5C9)
            cell.subTitle.text = "\(date) - Swipe to Reply"
        } else {
            cell.subTitle.text = "\(date) - Hold to Play"
            cell.statusLogo.textColor = UIColor(netHex:0x7FF2FF)
            cell.lengthLabel.backgroundColor = UIColor(netHex:0x7FF2FF)
        }
        // Unwatched vyncs get special background color
        if vyncs[indexPath.row].unwatched {
            let color = UIColor(netHex: 0xFFFF00)
            cell.backgroundColor = color
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        // Not yet uploaded vyncs/Not yet saved vyncs get special background color
        if vyncs[indexPath.row].notUploaded {
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.redColor().CGColor
            cell.lengthLabel.layer.borderWidth = 2.0
            cell.lengthLabel.layer.borderColor = UIColor.redColor().CGColor
        } else if vyncs[indexPath.row].isSaved == false {
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.orangeColor().CGColor
            cell.lengthLabel.layer.borderWidth = 2.0
            cell.lengthLabel.layer.borderColor = UIColor.orangeColor().CGColor
        } else {
            cell.contentView.layer.borderWidth = 0.0
            cell.lengthLabel.layer.borderWidth = 0.0
        }

        return cell
    }
    
    func addGesturesToCell(cell:UITableViewCell){
        // long touch for playback
        let longTouch = UILongPressGestureRecognizer()
        longTouch.addTarget(self, action: "holdToPlayVideos:")
        cell.addGestureRecognizer(longTouch)
        
        let singleTap = UITapGestureRecognizer(target: self, action: "singleTapCell:")
        singleTap.numberOfTapsRequired = 1
        
        let doubleTap = UITapGestureRecognizer(target:self, action: "doubleTapCell:")
        doubleTap.numberOfTapsRequired = 2
        
        cell.addGestureRecognizer(singleTap)
        cell.addGestureRecognizer(doubleTap)
        singleTap.requireGestureRecognizerToFail(doubleTap)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if vyncs[indexPath.row].waitingOnYou {
            return true
        } else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let replyClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            self.reply(indexPath.row)
        }
        
        let reply = UITableViewRowAction(
            style: UITableViewRowActionStyle.Normal,
            title: "FORWARD",
            handler: replyClosure
            )
        reply.backgroundColor = UIColor(netHex: 0xFFB5C9)
        return [reply]
    }
    
    
    @IBAction func holdToPlayVideos(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            if let index = self.vyncTable.indexPathForRowAtPoint(sender.view!.center)?.row as Int! {
                if vyncs[index].isSaved {
                    println("Videos here are saved")
                    if index == self.lastPlayed {
                        self.videoPlayer?.continuePlay()
                        self.videoPlayer!.view.addGestureRecognizer(sender)
                        if self.presentedViewController == nil {
                            self.presentViewController(self.videoPlayer!, animated: false, completion:nil)
                        }
                    } else {
                        self.videoPlayer?.view.removeGestureRecognizer(sender)
                        self.videoPlayer?.player = nil
                        self.videoPlayer = nil
                        vyncs[index].unwatched = false
                        self.lastPlayed = index
                        // waiting on you vs. following logic 
                        var urls : [NSURL]
                        if vyncs[index].waitingOnYou {
                            urls = vyncs[index].waitingVideoUrls()
                        }
                        else {
                            urls = vyncs[index].videoUrls()
                        }
                        self.videoPlayer = QueueLoopVideoPlayer()
                        self.videoPlayer!.view.addGestureRecognizer(sender)
                        self.videoPlayer!.videoList = urls
                        self.videoPlayer!.playVideos()
                        if self.presentedViewController == nil {
                            self.presentViewController(self.videoPlayer!, animated: false, completion:nil)
                        }
                    }
                }
            }
        }
        if sender.state == .Ended {
            self.videoPlayer?.stop()
            self.vyncTable.reloadData()
            self.vyncTable.setNeedsDisplay()
        }
    }
    
    func singleTapCell(sender:UITapGestureRecognizer){
        println("single tapped")
        let indexPath = self.vyncTable.indexPathForRowAtPoint(sender.view!.center)
        if let cell = vyncTable.cellForRowAtIndexPath(indexPath!) as? VyncCell {
            cell.selectCellAnimation()
            
            let index = indexPath!.row as Int
            let v = vyncs[index]
            println("This vync waiting on you=\(v.waitingOnYou)")
            for video in v.messages {
                println("Vid.\(video.id):\n watched?\(video.watched), saved?\(video.saved)")
            }
        }

    }
    
    func doubleTapCell(sender:UITapGestureRecognizer){
        let indexPath:NSIndexPath = self.vyncTable.indexPathForRowAtPoint(sender.view!.center)!
        if let cell = vyncTable.cellForRowAtIndexPath(indexPath) as? VyncCell {
            if cell.isFlipped {
                let view = self.view.viewWithTag(19)
                cell.isFlipped = false
                UIView.transitionFromView(
                    view!,
                    toView: cell.contentView,
                    duration: 0.66,
                    options: UIViewAnimationOptions.TransitionFlipFromBottom,
                    completion: nil
                )
            } else {
                let viewHeight = Int(cell.frame.height)
                let viewWidth = Int(cell.frame.width)
                let view = UIView(frame:CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
                let label = UILabel()
                label.frame = view.frame
                if vyncs[indexPath.row].waitingOnYou {
                    label.text = " Forward to see who is on this VYNC"
                    
                } else {
                    let labelText = ", ".join(vyncs[indexPath.row].usersList())
                    label.text = " Users: \(labelText)"

                }

                view.addSubview(label)
                view.tag = 19
                cell.isFlipped = true
                UIView.transitionFromView(
                    cell.contentView,
                    toView: view,
                    duration: 0.66,
                    options: UIViewAnimationOptions.TransitionFlipFromTop,
                    completion: {
                        finished in
                        // Auto flip back after 4 seconds
                        delay(4){
                            if cell.isFlipped {
                                self.doubleTapCell(sender)
                            }
                        }
                    })
            }
        }
    }

    func reply(index:Int){
        println("showing Reply Camera")
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
        let camera = self.storyboard?.instantiateViewControllerWithIdentifier("Camera") as VyncCameraViewController
        camera.vync = vyncs[index]
        self.presentViewController(camera, animated: false, completion: nil)
    }

    @IBAction func showCam() {
        println("showing Camera")
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
        let camera = self.storyboard?.instantiateViewControllerWithIdentifier("Camera") as VyncCameraViewController

        self.presentViewController(camera, animated: false, completion: nil)
    }
    
}
