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

public func avPlayerControllerFor(vidUrl: String) -> AVPlayerViewController {
    
    // create player controller
    let player = AVPlayer(URL: NSURL(string: vidUrl))
    
    // create player view controller
    let avPlayerVC = AVPlayerViewController()
    avPlayerVC.player = player
    
    return avPlayerVC
}