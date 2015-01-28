//
//  VideoMessage.swift
//  Chainer
//
//  Created by Apprentice on 11/11/14.
//  Copyright (c) 2014 DBC. All rights reserved.
//
//
//import Foundation
//import CoreData
//
//class VideoMessage: NSManagedObject {
//    
//    @NSManaged var createdAt: String
//    @NSManaged var videoID: String
//    @NSManaged var senderID: NSNumber
//    @NSManaged var recipientID: NSNumber
//    @NSManaged var messageID: NSNumber
//    @NSManaged var replyToID: NSNumber
//    @NSManaged var title: String
//    
//}


import Foundation
import UIKit
import CoreData

//func getName(classType:AnyClass) -> String {
//    
//    let classString = NSStringFromClass(classType)
//    let range = classString.rangeOfString(".", options: NSStringCompareOptions.CaseInsensitiveSearch, range: Range<String.Index>(start:classString.startIndex, end: classString.endIndex), locale: nil)
//    return classString.substringFromIndex(range!.endIndex)
//}


class UserX: NSManagedObject {
    
    @NSManaged var username: String
    @NSManaged var id: NSNumber
    
}

func createObjectFromJSON(decoder: JSONDecoder, db:NSManagedObjectContext){
    println(db)
    var user = NSEntityDescription.insertNewObjectForEntityForName("UserX", inManagedObjectContext: db) as UserX
    user.id = decoder["id"].integer as Int!
    user.username = decoder["username"].string as String!
}

let UserSyncer = Syncer<UserX>(entityName:"UserX", primaryKeyName:"id", url: "http://chainer.herokuapp.com/allusers")


//protocol SyncDelegate {
//    func createObjectsFromJSON(decoder:JSONDecoder, db:NSManagedObjectContext)
//}

class Syncer<T: NSManagedObject> {
    let primaryKeyName:String
    let entityName:String
    let url:String
    
    init(entityName:String, primaryKeyName:String, url:String) {
        self.url = url
        self.entityName = entityName
        self.primaryKeyName = primaryKeyName
    }
    
    // NSManaged Functions
    lazy var db : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
        }()
    
    var mostRecent : T? {
        get {
            var req = NSFetchRequest(entityName: entityName)
            req.sortDescriptors = [self.sortBy(primaryKeyName, ascending: false)]
            req.fetchLimit = 1
            var error: NSError?
            if let db = self.db {
                let results = db.executeFetchRequest(req, error: &error) as [T]
                if results.count == 1 {
                    return results[0]
                }
            }
            return nil
        }
    }
    
    func find(id : Int)-> T? {
        var req = NSFetchRequest(entityName: entityName)
        let format = "\(primaryKeyName) == %@"
        req.predicate = NSPredicate(format: format, argumentArray: [id])
        req.fetchLimit = 1
        var error: NSError?
        if let db = self.db {
            let results = db.executeFetchRequest(req, error: &error) as [T]
            if results.count == 1 {
                return results[0] as T
            }
        }
        return nil
    }

    func sortBy(key: NSString, ascending: Bool) -> NSSortDescriptor {
        return NSSortDescriptor(key: key, ascending: ascending)
    }
    
    // HTTP Functions
    func sync() {
        var since = 0
        
// TODO: Implement a better syncing method that actually works
//        if let sinceVid = self.mostRecent {
//            since = sinceVid[1] as Int
//        }
        var data : NSData?
        var request = HTTPTask()
        var deviceID = UIDevice.currentDevice().identifierForVendor.UUIDString
        request.GET(url,
            parameters: ["since" : since],
            success: { (response: HTTPResponse) in
                if response.responseObject != nil {
                    if let data = response.responseObject as? NSData {
                        println("json", JSONDecoder(data))
                        self.addJSONToSql(JSONDecoder(data))
//                        println(data)
                    }
                }

        })
    }

    func addJSONToSql(decoderArray: JSONDecoder) {
        for decoder in decoderArray.array! {
            if find(decoder["id"].integer as Int!) == nil {
                createObjectFromJSON(decoder, self.db!)
            }
        }
        db!.save(nil)
    }

    
}

//class VideoManager {
//    
//    lazy var db : NSManagedObjectContext? = {
//        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        if let managedObjectContext = appDelegate.managedObjectContext {
//            return managedObjectContext
//        } else {
//            return nil
//        }
//        }()
//    
//    var mostRecent : VideoMessage? {
//        get {
//            var req = NSFetchRequest(entityName: "VideoMessage")
//            req.sortDescriptors = [VideosManager.sortBy("messageID", ascending: false)]
//            req.fetchLimit = 1
//            var error: NSError?
//            if let db = self.db {
//                let results = db.executeFetchRequest(req, error: &error) as [VideoMessage]
//                if results.count == 1 {
//                    return results[0]
//                }
//            }
//            return nil
//        }
//    }
//    
//    func asChains() -> [[VideoMessage]] {
//        // declaring this at the top...using it below in the for loop and returning it.
//        var chains = [[VideoMessage]]()
//        // set the App delegate and managed context  before query.
//        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        let managedContext = appDelegate.managedObjectContext!
//        // define our fetch request. We are looking for a list of replyToIDs order of most recently created at.
//        let fetchRequest = NSFetchRequest(entityName:"VideoMessage")
//        let ed = NSEntityDescription.entityForName("VideoMessage",
//            inManagedObjectContext: managedContext)!
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "replyToID", ascending: true), NSSortDescriptor(key: "createdAt", ascending: false)]
//        fetchRequest.returnsDistinctResults = true
//        fetchRequest.propertiesToFetch = ["replyToID"]
//        var error: NSError?
//        // Make the request
//        let fetchedResults: [AnyObject]? = managedContext.executeFetchRequest(fetchRequest, error: &error)
//        // if the query worked as expected
//        if let results = fetchedResults as? [VideoMessage] {
//            // set data structures. Chain will be passed around and manipulated, we will be building into chains.
//            var chain = [VideoMessage]()
//            for video in results {
//                // If it's the first chain or it's on the same chain as the previous video add it to chain
//                if chain.isEmpty || chain.last!.replyToID == video.replyToID {
//                    chain.append(video)
//                } else {
//                    // Add the chain to chains and reset chain.
//                    chains.append(chain)
//                    chain = [video]
//                }
//            }
//            // Got to get that last one.
//            if chain.isEmpty == false {
//                chains.append(chain)
//            }
//        } else {
//            println("Could not fetch \(error), \(error!.userInfo)")
//        }
//        return chains
//    }
//    
//    
//    class func sortBy(key: NSString, ascending: Bool) -> NSSortDescriptor {
//        return NSSortDescriptor(key: key, ascending: ascending)
//    }
//    
//    func update() {
//        var since = 0
//        if let sinceVid = self.mostRecent {
//            since = sinceVid.messageID as Int
//        }
//        var data : NSData?
//        var request = HTTPTask()
//        var deviceID = UIDevice.currentDevice().identifierForVendor.UUIDString
//        request.GET("http://chainer.herokuapp.com/videomessages/\(deviceID)/all",
//            parameters: ["since" : since],
//            success: { (response: HTTPResponse) in
//                if response.responseObject != nil {
//                    if let data = response.responseObject as? NSData {
//                        println("json", JSONDecoder(data))
//                        self.addVideosToSql(JSONDecoder(data))
//                    }
//                }
//        })
//    }
//    
//    func createVideoFromJSON(decoder: JSONDecoder) -> VideoMessage {
//        var vid = NSEntityDescription.insertNewObjectForEntityForName("VideoMessage",
//            inManagedObjectContext: self.db!) as VideoMessage
//        vid.messageID = decoder["id"].integer as Int!
//        vid.replyToID = decoder["reply_to_id"].integer as Int!
//        vid.senderID =  decoder["sender_id"].integer as Int!
//        vid.recipientID = decoder["recipient_id"].integer as Int!
//        vid.videoID = decoder["video_id"].string as String!
//        vid.createdAt = decoder["created_at"].string as String!
//        return vid
//    }
//    
//    func addVideosToSql(decoderArray: JSONDecoder) {
//        for decoder in decoderArray.array! {
//            if find(decoder["id"].integer as Int!) == nil {
//                createVideoFromJSON(decoder)
//            }
//        }
//        db!.save(nil)
//    }
//    
//    func find(id : Int)-> VideoMessage? {
//        var req = NSFetchRequest(entityName: "VideoMessage")
//        req.predicate = NSPredicate(format: "messageID == %@", argumentArray: [id])
//        req.fetchLimit = 1
//        var error: NSError?
//        if let db = self.db {
//            let results = db.executeFetchRequest(req, error: &error) as [VideoMessage]
//            if results.count == 1 {
//                return results[0]
//            }
//        }
//        
//        return nil
//    }
//    
//}
//
