//
//  User.swift
//  VYNC
//
//  Created by Thomas Abend on 1/29/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import CoreData
@objc(User)
class User: NSManagedObject {
    
    class var syncer : Syncer<User> {
        return Syncer<User>(url: host + "/users")
    }
    
    
    @NSManaged var username: String
    @NSManaged var id: NSNumber
    @NSManaged var email: String
    @NSManaged var facebookObjectId: String
//  Using like a boolean: 1=true 0=false
    @NSManaged var isMe :NSNumber
    
}