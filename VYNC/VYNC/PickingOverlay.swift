//
//  PickingOverlay.swift
//  VYNC
//
//  Created by Thomas Abend on 1/24/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Foundation


class PickingOverlay: UIView {
    var playerLayer : AVPlayerLayer?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        frame = UIScreen.mainScreen().bounds
        backgroundColor = UIColor.clearColor()
        
    }
    
    @IBAction func retake() {
        println("retake")
        self.removeFromSuperview()
        if let player = self.playerLayer {
            player.removeFromSuperlayer()
        }
    }
}