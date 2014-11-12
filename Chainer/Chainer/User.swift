//
//  User.swift
//  Chainer
//
//  Created by Apprentice on 11/11/14.
//  Copyright (c) 2014 DBC. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var username: String
    @NSManaged var userID: NSNumber

}
