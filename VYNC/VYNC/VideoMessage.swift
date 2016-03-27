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
    return a.reduce([Int]()) { ac, x in ac.contains(x) ? ac : ac + [x] }
}
@objc(VideoMessage)
class VideoMessage: NSManagedObject {
    
    class var syncer : Syncer<VideoMessage> {
        return Syncer<VideoMessage>(url: host + "/users/\(myFacebookId())/videos")
    }
    
    @NSManaged var id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var createdAt: String?
    @NSManaged var videoId: String?
    @NSManaged var senderId: NSNumber?
    @NSManaged var recipientId: NSNumber?
    @NSManaged var replyToId: NSNumber?
    // 0 for false, 1 for true
    @NSManaged var watched: NSNumber?
    @NSManaged var saved: NSNumber?
    
    class func asVyncs()->[Vync]{
        let allVideos = self.syncer.all().sortBy("id", ascending: false).filter("saved == %@", args: 1).exec()!
        let replyTos = allVideos.map({video in Int(video.replyToId!)})
        var uniqReplyTos = remDupeInts(replyTos)
        uniqReplyTos.sortInPlace({$0 > $1})
        // remove id 0 to deal with it separately.
        if uniqReplyTos.last == 0 {
            uniqReplyTos.removeLast()
        }
        var vyncs = [Vync]()
        for id in uniqReplyTos {
            var messages = VideoMessage.syncer.all().filter("replyToId == %@", args: id).sortBy("id", ascending: false).exec()!
            // Deal with videos that haven't yet been uploaded
            if let lastMessage = messages.last as VideoMessage! {
                if lastMessage.id == 0 {
                    let lastMessage = messages.last
                    messages.removeLast()
                    messages.insert(lastMessage!, atIndex: 0)
                }
            }
            let newVync = Vync(messages: messages)
            vyncs.append(newVync)
        }
        // not yet uploaded, new thread:
        let newVideos = self.syncer.all().filter("id == %@ AND replyToId == %@", args: 0, 0).exec()!
        for video in newVideos {
            vyncs.insert(Vync(messages: [video]), atIndex: 0)
        }

        //return vyncs
        return vyncs.filter({vync in vync.dead() == false})
    }

    class func saveNewVids(completion:(()->()) = {}) {
        let vids = self.syncer.all().exec()!
        // This shouldn't be necessary, but filter is not working for the saved property for some reason
        let newVids : [VideoMessage] = vids.filter({video in video.saved == 0})
        if newVids.count == 0 {
            completion()
        }
        for message in newVids {
            let localUrlString = "\(docFolderToSaveFiles)/\(message.videoId!)"
            let localUrl = NSURL(fileURLWithPath: localUrlString) as NSURL!
            let cloudUrl = NSURL(string: s3Url + message.videoId!) as NSURL!
            let localData = NSData(contentsOfURL: localUrl)
            if localData?.length == nil {
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    print("saving video to core data \(message.id)")
                    let data = NSData(contentsOfURL: cloudUrl)
                    data?.writeToFile(localUrlString, atomically: true)
                    message.saved = 1
                    message.watched = 0
                    self.syncer.save()
                    dispatch_async(dispatch_get_main_queue()) {
                        // update some UI using completion callback
                        print("back on the main thread")
                        completion()
                    }
                }
            } else {
                print("already there")
                message.saved = 1
                self.syncer.save()
            }
        }
    }
}
