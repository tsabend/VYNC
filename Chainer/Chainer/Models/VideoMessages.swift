//
//  VideosMessages.swift
//  viewAllUsers
//
//  Created by Apprentice on 11/9/14.
//  Copyright (c) 2014 Apprentice. All rights reserved.
//

import Foundation
import UIKit

struct VideoMessage : JSONJoy {
    var messageID: Int?
    var replyToID: Int?
    var senderID: Int?
    var recipientID: Int?
    var videoID: String?
    var createdAt: String?

    init(_ decoder: JSONDecoder) {
        messageID = decoder["id"].integer as Int!
        replyToID = decoder["reply_to_id"].integer
        senderID = decoder["sender_id"].integer
        recipientID = decoder["recipient_id"].integer
        videoID = decoder["video_id"].string
        createdAt = decoder["created_at"].string
    }
    
}

struct VideoMessagesArray : JSONJoy {
    var videoMessages : [VideoMessage] = []
    
    init(_ decoder: JSONDecoder) {
        if let vms = decoder["video_messages"].array {
            videoMessages = [VideoMessage]()
            for vmDecoder in vms {
                videoMessages.append(VideoMessage(vmDecoder))
            }
        }
    }
}


class VideoMessageManager {
    var openVideoMessages = [VideoMessage]()
    var newVideoMessages = [VideoMessage]()
    var finishedVideoMessages = [VideoMessage]()
    
    init() {
        openVideoMessages = []
        newVideoMessages = []
        finishedVideoMessages = []
    }
    
    func getInitialValues() {
        getNewVideoMessages()
        getOpenVideoMessages()
        getFinishedVideoMessages()
    }
    
    func getNewVideoMessages() {
        var data : NSData?
        var request = HTTPTask()
        request.GET("http://localhost:9393/videomessages/1/new", parameters: nil, success: {(response: HTTPResponse) in // success
            if response.responseObject != nil {
                data = response.responseObject as? NSData
                self.newVideoMessages = VideoMessagesArray(JSONDecoder(data!)).videoMessages
                
            }
            },failure: {(error: NSError, response: HTTPResponse?) in //failure
                println("error: \(error)")
        })
    }

    func getOpenVideoMessages() {
        var data : NSData?
        var request = HTTPTask()
        request.GET("http://localhost:9393/videomessages/1/open", parameters: nil, success: {(response: HTTPResponse) in // success
            if response.responseObject != nil {
                data = response.responseObject as? NSData
                self.openVideoMessages = VideoMessagesArray(JSONDecoder(data!)).videoMessages

            }
            },failure: {(error: NSError, response: HTTPResponse?) in //failure
                println("error: \(error)")
        })
    }
    
    func getFinishedVideoMessages() {
        var data : NSData?
        var request = HTTPTask()
        request.GET("http://localhost:9393/videomessages/1/finished", parameters: nil, success: {(response: HTTPResponse) in // success
            if response.responseObject != nil {
                data = response.responseObject as? NSData
                self.finishedVideoMessages = VideoMessagesArray(JSONDecoder(data!)).videoMessages
            }
            },failure: {(error: NSError, response: HTTPResponse?) in //failure
                println("error: \(error)")
        })
    }  
    
}

let videoMessageMgr = VideoMessageManager()

