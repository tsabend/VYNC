//
//  Vync.swift
//  VYNC
//
//  Created by Thomas Abend on 1/25/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import CoreData

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
            NSURL.fileURLWithPath(docFolderToSaveFiles + "/" + message.videoId!) as NSURL!
        })
    }

    func replyToId()->Int {
        if let first = self.messages.last {
            return first.replyToId as Int
        } else {
            return 0
        }
    }
    
    func mostRecent()->String{
        return "TODO"
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        if let createdAt = messages.last?.createdAt {
//            if let date = formatter.dateFromString(createdAt) as NSDate! {
//                let uMonth = UInt(date.month)
//                let month = NSDateFormatterStyle(rawValue: uMonth)
//                return "\(month) \(date.day)"
//            } else {
//                return "oops"
//            }
//        } else {
//            return "Just now"
//        }
    }
    
    func title()->String {
        if self.messages.count != 0 {
        if let video = messages.first as VideoMessage! {
            if let title = video.title as String! {
                return title
            } else {
                return "TODO"
            }
        } else {
            return "ToDo"
        }
        } else {return "wtf"}
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
            self.findUsername(message.senderId as Int)
        })
    }
    
    func findUsername(userId:Int)->String{
//        let match = allUsers.filter({user in user.userId == userId})
//        return match.first!.username
        println(User.syncer.all().find(userId).first)
        if let user = User.syncer.all().find(userId).first as User! {
            return user.username
        } else {
            return "Fail :("
        }
    }
    
}
