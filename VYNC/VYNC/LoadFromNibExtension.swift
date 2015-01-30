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
    let range = classString.rangeOfString(".", options: NSStringCompareOptions.CaseInsensitiveSearch, range: Range<String.Index>(start:classString.startIndex, end: classString.endIndex), locale: nil)
    return classString.substringFromIndex(range!.endIndex)
}

extension UIView {
    
    
    class func loadFromNib() -> UIView? {
        println("loading nib")
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