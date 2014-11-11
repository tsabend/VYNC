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
    init() {
    }
    init(_ decoder: JSONDecoder) {
        messageID = decoder["id"].integer as Int!
        replyToID = decoder["reply_to_id"].integer as Int!
        senderID = decoder["sender_id"].integer as Int!
        recipientID = decoder["recipient_id"].integer as Int!
        videoID = decoder["video_id"].string as String!
        createdAt = decoder["created_at"].string as String!
    }
}

struct Chain : JSONJoy {
    var videoMessages : [VideoMessage] = []
    
    init() {
    }
    init(_ decoder: JSONDecoder) {
        if let vms = decoder.array {
            videoMessages = [VideoMessage]()
            for vmDecoder in vms {
                videoMessages.append(VideoMessage(vmDecoder))
            }
        }
    }
}

// This hard coding is to allow for more simple refactoring later.
let device_id = 1

class VideoMessageManager {
    var openChains = [Chain]()
    var newChains = [Chain]()
    var finishedChains = [Chain]()
    var chains = [Chain]()
    
    var chainsById = [ Int : Chain ]()
    
    func getInitialValues() {
//        getNewChains()
//        getOpenChains()
//        getFinishedChains()
        updateChains()
    }

    func updateChains() {
        var data : NSData?
        var request = HTTPTask()
        request.GET("http://chainer.herokuapp.com/videomessages/\(device_id)/all", parameters: nil,
            success: {(response: HTTPResponse) in
                if response.responseObject != nil {
                    data = response.responseObject as? NSData
                    var newMessages = [VideoMessage]()
                    JSONDecoder(data!).arrayOf(&newMessages)
                    for message in newMessages {
                        var chain = self.chainsById[message.replyToID!]
                        if chain == nil {
                            self.chainsById[message.replyToID!] = Chain()
                            chain = self.chainsById[message.replyToID!]
                        }
                        chain!.videoMessages.append(message)
                    }
                }
        })
    }
    
    
    func getNewChains() {
        var data : NSData?
        var request = HTTPTask()
        request.GET("http://chainer.herokuapp.com/videomessages/\(device_id)/new", parameters: nil,
            success: {(response: HTTPResponse) in
            if response.responseObject != nil {
                data = response.responseObject as? NSData
                JSONDecoder(data!).arrayOf(&self.newChains)
            }
        })
    }

    func getOpenChains() {
        var data : NSData?
        var request = HTTPTask()
        request.GET("http://chainer.herokuapp.com/videomessages/\(device_id)/open", parameters: nil,
            success: {(response: HTTPResponse) in
                if response.responseObject != nil {
                    data = response.responseObject as? NSData
                    JSONDecoder(data!).arrayOf(&self.openChains)
                }
        })
    }
    
    func getFinishedChains() {
        var data : NSData?
        var request = HTTPTask()
        request.GET("http://chainer.herokuapp.com/videomessages/\(device_id)/finished", parameters: nil,
            success: {(response: HTTPResponse) in
                if response.responseObject != nil {
                    data = response.responseObject as? NSData
                    JSONDecoder(data!).arrayOf(&self.finishedChains)
                }
        })
    }

}

let videoMessageMgr = VideoMessageManager()

