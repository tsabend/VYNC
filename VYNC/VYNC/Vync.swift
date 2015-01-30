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
