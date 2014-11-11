//
//  VideoPlayer.swift
//  Chainer
//
//  Created by Faraaz Nishtar on 11/11/14.
//  Copyright (c) 2014 DBC. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Foundation

public func avPlayerControllerFor(url: String) -> AVPlayerViewController {
    // create player controller
//    let testUrl = "https://s3-us-west-2.amazonaws.com/telephono/395998122c2e7ba0e06ce82a71dac347.mov?"
    let player: AVPlayer = AVPlayer(URL: NSURL(string: url))

    // create player view controller
    let avPlayerVC = AVPlayerViewController()
    avPlayerVC.player = player
    
    return avPlayerVC
}

public func playVidUrlOnViewController(vidUrl: String, vc: UIViewController) {
    
    let avPlayerVC = avPlayerControllerFor(vidUrl)
    
    // show player view controller
    vc.presentViewController(avPlayerVC, animated: true, completion: {
        // start playing
        println("playing \(avPlayerVC.player.currentItem)")
        println("status before play = \(avPlayerVC.player.status.rawValue)")
        avPlayerVC.player.play()
         println("status after play = \(avPlayerVC.player.status.rawValue)")
        
    })
    
}