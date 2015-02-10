//
//  VideoMessage.swift
//  VYNC
//
//  Created by Thomas Abend on 1/30/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import CoreData

func remDupeInts(a:[Int]) -> [Int] {
    return a.reduce([Int]()) { ac, x in contains(ac, x) ? ac : ac + [x] }
}

class VideoMessage: NSManagedObject {
    
    class var syncer : Syncer<VideoMessage> {
        return Syncer<VideoMessage>(url: "http://192.168.0.6:9393/users/\(myFacebookId())/videos")
    }
    
    @NSManaged var id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var createdAt: String?
    @NSManaged var videoId: String?
    
    @NSManaged var senderId: NSNumber?
    @NSManaged var recipientId: NSNumber?
    @NSManaged var replyToId: NSNumber?
        
    class func asVyncs()->[Vync]{
        // TODO: Make this code better!
        let allVideos = self.syncer.all().sortBy("id", ascending: false).exec()!
        let ids = allVideos.map({video in video.id as Int})
        let replyTos = allVideos.map({video in video.replyToId as Int})
        var uniqReplyTos = remDupeInts(replyTos)
        // remove id 0 to deal with it separately.
        if uniqReplyTos.last == 0 {
            uniqReplyTos.removeLast()
        }
        var vyncs = [Vync]()
        for id in uniqReplyTos {
            let messages = VideoMessage.syncer.all().filter("replyToId == %@", args: id).sortBy("id", ascending: false).exec()!
            let newVync = Vync(messages: messages)
            vyncs.append(newVync)
        }
        
        // not yet uploaded:
        let newVideos = self.syncer.all().filter("id == %@", args: 0).exec()!
        for video in newVideos {
            vyncs.insert(Vync(messages: [video]), atIndex: 0)
        }
//        for vync in vyncs {
//            for message in vync.messages {
//                println(message.id)
//            }
//        }
        return vyncs
    }
    
    func saveVid(){
    
    }
    
    class func saveNewVids() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            for message in self.syncer.all().exec()! {
                let localUrlString = docFolderToSaveFiles + "/" + message.videoId!
                let localUrl = NSURL(fileURLWithPath: localUrlString) as NSURL!
                let cloudUrl = NSURL(string: s3Url + message.videoId!) as NSURL!
                
                let localData = NSData(contentsOfURL: localUrl)
                
                if localData?.length == nil {
                    println("saving to core data")
                    let data = NSData(contentsOfURL: cloudUrl)
                    data?.writeToFile(localUrlString, atomically: true)
                } else {
                    println(localData?.length)
                    println("already there")
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
            }
        }
    }
}
