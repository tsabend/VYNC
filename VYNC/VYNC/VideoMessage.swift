//
//  VideoMessage.swift
//  VYNC
//
//  Created by Thomas Abend on 1/30/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import CoreData

class VideoMessage:NSManagedObject {
    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var createdAt: String
    @NSManaged var videoId: String
    
    @NSManaged var senderId: NSNumber
    @NSManaged var recipientId: NSNumber
    @NSManaged var replyToId: NSNumber
}
