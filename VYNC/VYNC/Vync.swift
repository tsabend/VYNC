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
    var notUploaded: Bool {
        get {
            return self.messages.first!.id == 0
        }
    }
    var waitingOnYou: Bool {
        get {
            return myUserId() == self.messages.last?.recipientId
        }
    }
    
    init(messages: [VideoMessage]){
        self.messages = messages
    }

    func size()-> String{
        return "\(self.messages.count)"
    }
    
    func videoUrls()->[NSURL]{
        return self.messages.map({
            message in
            NSURL.fileURLWithPath(docFolderToSaveFiles + "/" + message.videoId!) as NSURL!
        })
    }
    
    func waitingVideoUrls()->[NSURL]{
        let message = self.messages.first!
        let messageUrl = NSURL.fileURLWithPath(docFolderToSaveFiles + "/" + message.videoId!) as NSURL!
        return [messageUrl, standin]
    }

    func replyToId()->Int {
        if let first = self.messages.last {
            return first.replyToId as Int
        } else {
            return 0
        }
    }
    
    func mostRecent()->String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let createdAt = messages.last?.createdAt {
            if let date = formatter.dateFromString(createdAt) as NSDate! {
                return "\(date.mediumDateString)"
            } else {
                return "oops"
            }
        } else {
            return "Just now"
        }
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
        } else {return "oops"}
    }
    
    func usersList()->[String]{
        return self.messages.map({
            message in
            self.findUsername(message.senderId as Int)
        })
    }
    
    func findUsername(userId:Int)->String{
        println(User.syncer.all().find(userId).first)
        if let user = User.syncer.all().find(userId).first as User! {
            return user.username
        } else {
            return "Fail :("
        }
    }
    
}
