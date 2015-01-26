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
    
    @IBAction func remove() {
        println("removing layer")
        self.removeFromSuperview()
        if let player = self.playerLayer {
            player.removeFromSuperlayer()
        }
    }

    @IBAction func selectVync(sender: AnyObject) {
//        let vc = 
//            storyboard?.instantiateViewControllerWithIdentifier("Contacts") as ContactsViewController
//        vc.replyToID = self.replyToID
//        self.presentViewController(vc, animated:false, completion:{
//            self.replyToID = 0
//        })
    }
    
}