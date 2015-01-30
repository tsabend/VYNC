//
//  Vync.swift
//  VYNC
//
//  Created by Thomas Abend on 1/25/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import CoreData

func remDupeInts(a:[Int]) -> [Int] {
    return a.reduce([Int]()) { ac, x in contains(ac, x) ? ac : ac + [x] }
}

func asVyncs()->[Vync]{
    // TODO: Make this code better!
    let allVideos = vyncSyncer.all().exec()!
    let replyTos = allVideos.map({video in video.replyToId as Int})
    let uniqReplyTos = remDupeInts(replyTos)
    var vyncs = [Vync]()
    for id in uniqReplyTos {
        let messages = vyncSyncer.all().filter("replyToId == %@", args: id).exec()!
        let newVync = Vync(messages: messages)
        vyncs.append(newVync)
    }
    return vyncs
}

class Vync {

    var messages : [VideoMessage]
    var unwatched: Bool = true
    
    init(messages: [VideoMessage]){
        self.messages = messages
    }

    func size()-> String{
        return "\(self.messages.count)"
    }
    
    func waitingOnYou() -> Bool{
        return yourUserId == self.messages.last?.recipientId
    }
    
    func videoUrls()->[NSURL]{
        return self.messages.map({
            message in
            NSURL.fileURLWithPath(docFolderToSaveFiles + "/" + message.videoId) as NSURL!
        })
    }
    
    func saveNewVids() {
        for message in messages {
            let localUrlString = docFolderToSaveFiles + "/" + message.videoId
            let localUrl = NSURL(fileURLWithPath: localUrlString) as NSURL!
            let cloudUrl = NSURL(string: s3Url + message.videoId) as NSURL!
            
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
    }

    func replyToId()->Int {
        if let first = self.messages.first {
            return first.replyToId as Int
        } else {
            return 0
        }
    }
    
    func title()->String {
        return "TODO"
//        if let first = self.messages.first {
//            return first.title
//        } else {
//            return "Oops"
//        }
    }
//    Will eventually be replaced with SQL statements
    func usersList()->[String]{
        return self.messages.map({
            message in
            self.findUsername(message.senderId)
        })
    }
    
    func findUsername(userId:NSNumber)->String{
//        let match = allUsers.filter({user in user.userId == userId})
//        return match.first!.username
        return "TODO"
    }
    
}
