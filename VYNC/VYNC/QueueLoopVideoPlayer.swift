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
    var timer = UILabel(frame: CGRectMake(30, 30, 60, 60))
    var currentItemDuration = 0
    
    override func viewDidLoad() {
        videoGravity = AVLayerVideoGravityResizeAspectFill
        showsPlaybackControls = false
        let color = UIColor(netHex:0x73A1FF)
        let font = UIFont(name: "Egypt 22", size: 60)
        self.timer.font = font
        self.timer.text = ""
        self.timer.textColor = color
        self.view.addSubview(timer)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func playVideos(){
        let items = self.videoList.map({video in AVPlayerItem(URL:video)})
        self.player = AVQueuePlayer(items: items) as AVQueuePlayer!
        
        let duration = Int(round(CMTimeGetSeconds(items.first!.asset.duration)))
        self.currentItemDuration = duration
        self.player.addPeriodicTimeObserverForInterval(
            CMTimeMake(1,1),
            queue: dispatch_get_main_queue(),
            usingBlock: {
                (callbackTime: CMTime) -> Void in
                let t1 = CMTimeGetSeconds(callbackTime)
                let t2 = Int(CMTimeGetSeconds(self.player!.currentTime()))
                self.timer.text = "\(self.currentItemDuration - t2)"
        })
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "repeat:", name: "AVPlayerItemDidPlayToEndTimeNotification", object: nil)
        self.player.play()    
    }
    
    func continuePlay() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "repeat:", name: "AVPlayerItemDidPlayToEndTimeNotification", object: nil)
        self.player.play()
    }
    
    func stop(){
        self.player.pause()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "AVPlayerItemDidPlayToEndTimeNotification", object: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    func repeat(notification:NSNotification){
        if let playerItem = notification.object as? AVPlayerItem {
            let asset = playerItem.asset
            let copyOfPlayerItem = AVPlayerItem(asset: asset)
            let player = self.player as! AVQueuePlayer
            player.insertItem(copyOfPlayerItem, afterItem: nil)
            // Get the duration of the upcoming video to display countdown
            let second = player.items()[1] as! AVPlayerItem
            let duration = Int(round(CMTimeGetSeconds(second.duration)))
            self.currentItemDuration = duration

        }
    }

    deinit {
        println("queue deinit")
        self.player = nil;
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "AVPlayerItemDidPlayToEndTimeNotification", object: nil)
    }

}