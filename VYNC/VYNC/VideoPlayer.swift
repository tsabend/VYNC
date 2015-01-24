//
//  VideoPlayer.swift
//  VYNC
//
//  Created by Thomas Abend on 1/22/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Foundation

public func createAVItems(items : [String]) -> [AVPlayerItem]{
    var avItems : [AVPlayerItem] = []
    for i in 1...10 {
        for item in items {
            avItems.append(AVPlayerItem(URL: NSURL(string: item)))
        }
    }
    return avItems
}

public func createAVItems(items : [NSURL]) -> [AVPlayerItem]{
    var avItems : [AVPlayerItem] = []
    for i in 1...10 {
        for item in items {
            avItems.append(AVPlayerItem(URL:item))
        }
    }
    return avItems
}

public func videoPlayer(videos:[NSURL]) -> AVPlayerLayer {
    var urlsToPlay = createAVItems(videos)
    let player = AVQueuePlayer(items: urlsToPlay)// NSURL(string: url)
    let layer = AVPlayerLayer(player: player)

    UIApplication.sharedApplication().statusBarHidden=true
    var bounds = UIScreen.mainScreen().bounds
    layer.bounds = bounds
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill
    layer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
    return layer
}
