//
//  UIView+createFromXib.swift
//  ViewPlayground
//
//  Created by Kocsis Olivér on 2014.12.22..
//  Copyright (c) 2014 swiftosis. All rights reserved.

import Foundation
import UIKit
func getName(classType:AnyClass) -> String {
    
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