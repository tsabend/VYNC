//
//  GlobalVars.swift
//  VYNC
//
//  Created by Thomas Abend on 1/30/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Some publics funcs

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate {
    public var day: Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: self).day
    }
    
    public var month: Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: self).month
    }
    
    public var year: Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear, fromDate: self).year
    }
    
    public func isSameDay(date: NSDate) -> Bool {
        return (self.day == date.day && self.month == date.month && self.year == date.year)
    }
}

// DECLARE SOME GLOBAL VARS

//let standin = "https://s3-us-west-2.amazonaws.com/telephono/IMG_0370.MOV"
let path = NSBundle.mainBundle().pathForResource("IMG_0370", ofType:"MOV")
let unlockUrl : String = "https://s3-us-west-2.amazonaws.com/telephono/IMG_0370.MOV"

let remoteStandin = NSURL.fileURLWithPath(unlockUrl) as NSURL!

let standin = NSURL.fileURLWithPath(path!) as NSURL!
let s3Url = "https://s3-us-west-2.amazonaws.com/telephono/"

let docFolderToSaveFiles = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

let fileName = "/videoToSend.MOV"
let pathToFile = docFolderToSaveFiles + fileName


var db : NSManagedObjectContext? = {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    if let managedObjectContext = appDelegate.managedObjectContext {
        return managedObjectContext
    } else {
        return nil
    }
    }()

// Fake Data
var allUsers : [User] = User.syncer.all().exec()!

let yourUserId = 67