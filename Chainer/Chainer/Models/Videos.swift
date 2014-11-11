//  VideosMessages.swift
//  viewAllUsers
//
//  Created by Apprentice on 11/9/14.
//  Copyright (c) 2014 Apprentice. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Videos {
    lazy var db : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
    }()
    
    var mostRecent : VideoMessage? {
        get {
            var req = NSFetchRequest(entityName: "VideoMessage")
            req.sortDescriptors = [Videos.sortBy("messageID", ascending: false)]
            req.fetchLimit = 1
            var error: NSError?
            if let db = self.db {
                let results = db.executeFetchRequest(req, error: &error) as [VideoMessage]
                if results.count == 1 {
                    return results[0]
                }
            }
            return nil
        }
    }
    
    
    class func sortBy(key: NSString, ascending: Bool) -> NSSortDescriptor {
        return NSSortDescriptor(key: key, ascending: ascending)
    }
    
    func update() {
        var since = 0
        if let sinceVid = self.mostRecent {
            since = sinceVid.messageID as Int
        }
        
        var data : NSData?
        var request = HTTPTask()
        request.GET("http://chainer.herokuapp.com/videomessages/\(device_id)/all",
            parameters: ["since" : since],
            success: { (response: HTTPResponse) in
                if response.responseObject != nil {
                    if let data = response.responseObject as? NSData {
                        self.addVideosToSql(JSONDecoder(data))
                    }
                }
        })
    }
    
    func createVideoFromJSON(decoder: JSONDecoder) -> VideoMessage {
        var vid = NSEntityDescription.insertNewObjectForEntityForName("VideoMessage",
            inManagedObjectContext: self.db!) as VideoMessage
        vid.messageID = decoder["id"].integer as Int!
        vid.replyToID = decoder["reply_to_id"].integer as Int!
        vid.senderID =  decoder["sender_id"].integer as Int!
        vid.recipientID = decoder["recipient_id"].integer as Int!
        vid.videoID = decoder["video_id"].string as String!
        vid.createdAt = decoder["created_at"].string as String!
        return vid
    }
    
    func addVideosToSql(decoderArray: JSONDecoder) {
        for decoder in decoderArray.array! {
            createVideoFromJSON(decoder)
        }
        db!.save(nil)
    }

}

