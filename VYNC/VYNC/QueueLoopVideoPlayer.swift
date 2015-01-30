//
//  QueueLoopVideoPlayer.swift
//  VYNC
//
//  Created by Thomas Abend on 1/27/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import AVKit

class QueueLoopVideoPlayer : AVPlayerViewController {
    var videoList : [NSURL] = []
    var touchUp : UILongPressGestureRecognizer?
    
    override func viewDidLoad() {
        videoGravity = AVLayerVideoGravityResizeAspectFill
        showsPlaybackControls = false
        let press = UILongPressGestureRecognizer(target: self, action: "end:")
        self.view.addGestureRecognizer(press)

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func playVideos(){
        let items = self.videoList.map({video in AVPlayerItem(URL:video)})
        println("play Videos Was CALLED")
        println("********** items \(items)  *********")
        self.player = AVQueuePlayer(items: items)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "repeat:", name: "AVPlayerItemDidPlayToEndTimeNotification", object: nil)
        self.player.play()

        
    }
    
    func stop(){
        println("dismissing")
        self.player.pause()
        self.dismissViewControllerAnimated(false, completion: nil)
//        removeFromParentViewController()

    }

    func repeat(notification:NSNotification){
        if let playerItem = notification.object as? AVPlayerItem {
            let asset = playerItem.asset
            let copyOfPlayerItem = AVPlayerItem(asset: asset)
            let player = self.player as AVQueuePlayer
            player.insertItem(copyOfPlayerItem, afterItem: nil)

        }
    }

    deinit {
        self.player = nil;
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "AVPlayerItemDidPlayToEndTimeNotification", object: nil)
    }

}