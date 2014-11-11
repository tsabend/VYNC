//  VideosMessages.swift
//  viewAllUsers
//
//  Created by Apprentice on 11/9/14.
//  Copyright (c) 2014 Apprentice. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class VideoMessageManager {
    lazy var db : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
    }()
    
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

    //var videos = [VideoMessage]()
    
//    var chainsById = [ Int : Chain ]()
    
    func getInitialValues() {

        updateChains()
    }
    

    func updateChains() {
        var data : NSData?
        var request = HTTPTask()
        request.GET("http://chainer.herokuapp.com/videomessages/\(device_id)/all", parameters: nil,
            success: {(response: HTTPResponse) in
                if response.responseObject != nil {
                    data = response.responseObject as? NSData
                    if let data = response.responseObject as? NSData {
                        let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("response from all vms: \(str)") //prints the HTML of the page
                    }
                    var newMessages = [VideoMessage]()
//                    JSONDecoder(data!).arrayOf(&newMessages)
//                    self.addVideos(newMessages)
                    self.addVideosToSql(JSONDecoder(data!))
                }
        })
    }

    
    func addVideosToSql(decoderArray: JSONDecoder) {

        for decoder in decoderArray.array! {
//            println("Adding message with attributes: \(message.attributes)")
            createVideoFromJSON(decoder)
        }
    }

}

