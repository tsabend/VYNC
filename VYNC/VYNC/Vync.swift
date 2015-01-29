//
//  Vync.swift
//  VYNC
//
//  Created by Thomas Abend on 1/25/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import CoreData

let vyncSyncer = Syncer<VideoMessageX>(url: "http://chainer.herokuapp.com/videomessages/C60397E6-DF95-4F65-9E2F-86C7B045E5F3/all")

class VideoMessageX:NSManagedObject {
    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var createdAt: String
    @NSManaged var videoId: String
    
    @NSManaged var senderId: NSNumber
    @NSManaged var recipientId: NSNumber
    @NSManaged var replyToId: NSNumber
}

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

class VideoMessage {
//    The primary key
    let messageID: NSNumber
//    The video's filename
    let videoID : String
//    The sender
    let senderID:NSNumber
//    The recipient
    let recipientID: NSNumber
//    The start of the chain
    let replyToID:NSNumber
//    The title: only the start of the chain has a title
    let title:String?
//    Created at
    let createdAt:String

    init(videoID: String, senderID:NSNumber, recipientID: NSNumber, messageID: NSNumber, replyToID:NSNumber, createdAt:String, title:String? = nil ){
        self.messageID = messageID
        self.videoID = videoID
        self.senderID = senderID
        self.recipientID = recipientID
        self.replyToID = replyToID
        self.createdAt = createdAt
        self.title = title
    }
    
}

class Vync {

    var messages : [VideoMessageX]
    var unwatched: Bool = true
    
    init(messages: [VideoMessageX]){
        self.messages = messages
    }

    func size()-> String{
        return "\(self.messages.count)"
    }
    
    func waitingOnYou() -> Bool{
        return yourUserId == self.messages.last?.recipientId
    }
    
//    func videoUrls()->[NSURL]{
//        return self.messages.map({
//            message in
//            NSURL(string: s3Url + message.videoId) as NSURL!
//        })
//    }

    func videoUrls()->[NSURL]{
        return self.messages.map({
            message in
            NSURL.fileURLWithPath(pathToFile + "/" + message.videoId)
        })
    }

    
    func saveNewVids() {
        for message in messages {
            let localUrlString = pathToFile + "/" + message.videoId
            let localUrl = NSURL(fileURLWithPath: localUrlString)
            let cloudUrl = NSURL(string: s3Url + message.videoId) as NSURL!
            if let exists:NSURL = localUrl {
                println("already there")
            } else {
                println("saving to core data")
                let data = NSData(contentsOfURL: cloudUrl)
                data?.writeToFile(localUrlString, atomically: true)
                println("holy shit that worked i think")
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

class User {
    let username : String
    let userID : NSNumber
    
    init(username:String,userID:NSNumber){
        self.username = username
        self.userID = userID
    }

}

// Fake Data
var allUsers : [User]  = [
    User(username: "John", userID:1),
    User(username: "Misty", userID:2),
    User(username: "Frank", userID:3),
    User(username: "Gretta", userID:4),
    User(username: "Philippian", userID:5),
]

let yourUserId = 1

//// Vync 1 - Long vync you are following
//let message1 : VideoMessage = VideoMessage(videoID: path!, senderID: 1, recipientID: 2, messageID: 1, replyToID: 1, createdAt: "January 20" , title: "Check out my cat!")
//let message2 : VideoMessage = VideoMessage(videoID: path!, senderID: 2, recipientID: 4, messageID: 2, replyToID: 1, createdAt: "January 20")
//let message3 : VideoMessage = VideoMessage(videoID: path!, senderID: 4, recipientID: 3, messageID: 3, replyToID: 1, createdAt: "January 20")
//let message4 : VideoMessage = VideoMessage(videoID: path!, senderID: 3, recipientID: 2, messageID: 4, replyToID: 1, createdAt: "January 20")
//
//let vync1 : Vync = Vync(messages:[message1, message2, message3, message4])
//
//// Vync 2 - Short vync you are following
//let message5 : VideoMessage = VideoMessage(videoID: path!, senderID: 2, recipientID: 1, messageID: 5, replyToID: 5, createdAt: "January 24", title: "This Vync is unreal")
//let message6 : VideoMessage = VideoMessage(videoID: path!, senderID: 1, recipientID: 5, messageID: 6, replyToID: 5, createdAt: "January 24")
//
//let vync2 : Vync = Vync(messages: [message5, message6])
//
////Vync 3 - Long Vync you are holding up
//let message7 : VideoMessage = VideoMessage(videoID: path!, senderID: 5, recipientID: 4, messageID: 7, replyToID: 7, createdAt: "January 23", title: "If I were a bannanna")
//let message8 : VideoMessage = VideoMessage(videoID: path!, senderID: 4, recipientID: 3, messageID: 8, replyToID: 7, createdAt: "January 25")
//let message9 : VideoMessage = VideoMessage(videoID: path!, senderID: 3, recipientID: 2, messageID: 9, replyToID: 7, createdAt: "January 25")
//let message10 : VideoMessage = VideoMessage(videoID: path!, senderID: 2, recipientID: 1, messageID: 10, replyToID: 7, createdAt: "January 25")
//
//let vync3 = Vync(messages: [message7, message8, message9, message10])
//
////Vync 4 - Short vync you are holding up
//let message11 : VideoMessage = VideoMessage(videoID: path!, senderID: 4, recipientID: 1, messageID: 11, replyToID: 12, createdAt: "January 24" , title: "Woo!")
//
//let vync4 = Vync(messages: [message11])
//
////Vync 5 - Vync you just sent
//let message12 : VideoMessage = VideoMessage(videoID: "crazyvideo.com", senderID: 1, recipientID: 2, messageID: 12, replyToID: 12, createdAt: "January 25" , title: "Too many cooks?")
//
//let vync5 = Vync(messages: [message12])
//
//
var vyncList: [Vync] = asVyncs()