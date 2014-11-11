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

public func avPlayerControllerFor(url: NSURL) -> AVPlayerViewController {
    // create player controller
    let player: AVPlayer = AVPlayer(URL: url)

    // create player view controller
    let avPlayerVC = AVPlayerViewController()
    avPlayerVC.player = player
    
    return avPlayerVC
}

public func playVidUrlOnViewController(vidUrl: NSURL, vc: UIViewController) {
    
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