//
//  GlobalVars.swift
//  VYNC
//
//  Created by Thomas Abend on 1/30/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation

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


// Fake Data
var allUsers : [User] = User.syncer.all().exec()!

let yourUserId = 67