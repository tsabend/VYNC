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

public func avPlayerControllerFor(url: [AVPlayerItem]) -> AVPlayerViewController {
    let player: AVQueuePlayer = AVQueuePlayer(items: url)// NSURL(string: url)
    // create player view controller
    let avPlayerVC = AVPlayerViewController()
    avPlayerVC.player = player
    
    return avPlayerVC
}

public func playVidUrlOnViewController(vidUrl: [String], vc: UIViewController) {
    
    let avPlayerVC = avPlayerControllerFor(createAVItems(vidUrl))
    
    // show player view controller
    vc.presentViewController(avPlayerVC, animated: false, completion: {
        avPlayerVC.player.play()
    })
    
}
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

class VyncPlayer:AVPlayerViewController {
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        println("touchended")
    }
    
}