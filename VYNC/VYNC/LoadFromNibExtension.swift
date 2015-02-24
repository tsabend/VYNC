//
//  UIView+createFromXib.swift
//  ViewPlayground
//
//  Created by Kocsis Olivér on 2014.12.22..
//  Copyright (c) 2014 swiftosis. All rights reserved.

import Foundation
import UIKit

public func getName(classType:AnyClass) -> String {
    let classString = NSStringFromClass(classType)
    let swiftClassString = "\(classString)"
    let arr : [String] = swiftClassString.componentsSeparatedByString(".")
    return arr.last!
}

extension UIView {
    
    
    class func loadFromNib() -> UIView? {
        return self.loadFromNib(named: getName(self))
    }
    
    class func loadFromNib(named nibName:String) -> UIView? {
        let nibContents = NSBundle.mainBundle().loadNibNamed(nibName,owner: nil, options: nil) as NSArray
        
        if let actualView = nibContents.lastObject as? UIView {
            return actualView
        }
        
        return nil
    }
    
}

public func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}