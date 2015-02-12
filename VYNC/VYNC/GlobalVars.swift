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

// DECLARE SOME GLOBAL VARS

//let standin = "https://s3-us-west-2.amazonaws.com/telephono/IMG_0370.MOV"
let path = NSBundle.mainBundle().pathForResource("IMG_0370", ofType:"MOV")
let standin = NSURL.fileURLWithPath(path!) as NSURL!
let s3Url = "https://s3-us-west-2.amazonaws.com/telephono/"

let screenSize = UIScreen.mainScreen().bounds

let docFolderToSaveFiles = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
let fileName = "/videoToSend.MOV"
let pathToFile = docFolderToSaveFiles + fileName

let host = "http://192.168.0.6:9393" //"https://vync-api.herokuapp.com"
//"http://10.0.2.77:9393"
// "http://192.168.0.6:9393"


var db : NSManagedObjectContext? = {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    if let managedObjectContext = appDelegate.managedObjectContext {
        return managedObjectContext
    } else {
        return nil
    }
    }()

public func signedUp()->Bool{
    if let user = User.syncer.all().filter("isMe == %@", args: 1).exec()?.first as User! {
        return true
    } else {
        return false
    }
}

// Fake Data

var allUsers : [User] = User.syncer.all().exec()!

func myUserId()->Int?{
    if let me = User.syncer.all().filter("isMe == %@", args: 1).exec()!.first as User! {
        return me.id as? Int
        
    } else {
        return nil
    }
    
}

func myFacebookId()->String{
    if let me = User.syncer.all().filter("isMe == %@", args: 1).exec()!.first as User! {
        return me.facebookObjectId as String
        
    } else {
        return ""
    }
    
}

