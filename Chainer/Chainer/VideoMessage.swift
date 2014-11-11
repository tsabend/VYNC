//
//  VideoMessage.swift
//  Chainer
//
//  Created by Apprentice on 11/11/14.
//  Copyright (c) 2014 DBC. All rights reserved.
//

import Foundation
import CoreData

class VideoMessage: NSManagedObject {

    @NSManaged var createdAt: String
    @NSManaged var videoID: String
    @NSManaged var senderID: NSNumber
    @NSManaged var recipientID: NSNumber
    @NSManaged var messageID: NSNumber
    @NSManaged var replyToID: NSNumber

}
