//
//  Syncer.swift
//  Chainer
//
//  Created by Thomas Abend on 1/29/15.
//  Copyright (c) 2014 DBC. All rights reserved.

import Foundation
import UIKit
import CoreData


class Syncer<T: NSManagedObject> {
    let entityName:String
    let url:String
    let entityDescription:NSEntityDescription!
    
    // NSManaged Functions
    var db : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
    }()
    
    init(url:String) {
        self.url = url
        self.entityName = getName(T)
        self.entityDescription = NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: self.db!)
    }
    
    func all() -> AR<T> {
        return AR<T>()
    }
    
    // HTTP Functions
    func sync(completion:(()->()) = {}) {
        uploadNew()
        downloadNew()
    }
    
    func uploadNew(completion:(()->()) = {}){
        // post the video that the user takes to the server
        let newObjs = all().filter("id == %@", args: 0).exec()!
        if newObjs.count == 0 {
            completion()
        }
        for obj in newObjs {
            if let video = obj as? VideoMessage {
                print("Uploading video")
                uploadWithFile(obj, completion: completion)
            } else {
                print("Uploading user")
                upload(obj)
            }
        }
    }
    
// This is upload vs. uploadWithObject is an ad hoc solution to deal with sycning video uploads and user uploads differently
// I really dislike this solution. Ideally I would subclass NSManagedObject with HTTPManagedObject
// and have videomessage and user inherit from this superclass. Then I could just override the
// upload method from the parent. While this may still be possible, it is very difficult to do since
// NSManagedObject can't have non-stored variables. I also considered making a protocol and calling
// the upload method from the delegates, but given that I have only two objects, this made the code
// messier in my opinion. I want something that works for now, but I'd like to refactor this code.
    func upload(obj:T){
        let request = HTTPTask()
        let json = createJSONfromObject(obj)
        request.POST(url, parameters: ["json": json],
            success: {(response: HTTPResponse) in
                if let data = response.responseObject as? NSData {
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    if let id = Int((str! as String)) {
                        // This is an edge case where the item exists on the phone already with the right id. i.e a user deletes and reinstalls the app
                        if let exists = self.all().find(id) as T! {
                            self.db?.deleteObject(exists)
                            self.save()
                        }
                        print("new id=\(id)")
                        
                        (obj as NSManagedObject).setValue(id, forKey: "id")
                        
                        self.save()
                    } else {
                        print(str)
                    }
                }
            },failure: {(error: NSError, response: HTTPResponse?) in
                print("error: \(error)")
        })
    }
    
    func uploadWithFile(obj:T, completion: (()->()) = {}) {
        let json = createJSONfromObject(obj)
        let video = obj as! VideoMessage
        let videoURL = NSURL.fileURLWithPath(docFolderToSaveFiles + "/" + video.videoId!)
        var request = HTTPTask()
        request.POST(url,
            parameters:
            [
                "json": json,
                "file": HTTPUpload(fileUrl: videoURL)
            ],
            success: {(response: HTTPResponse) in
                if let data = response.responseObject as? NSData {
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                    // Using split to send back 3 variables is not a very robust solution. 
                    // This is just a short term fix.
                    var params = str.componentsSeparatedByString(",")
                    if let id = Int(params[0]) {
                        video.id = id
                        video.createdAt = params[1]
                        if video.replyToId == 0 {
                            video.replyToId = Int(params[2])
                        }
                        print("Video Synced")
                        self.save()
                        completion()
                    } else {
                        print("API error ",str)
                    }
                }
            },failure: {(error: NSError, response: HTTPResponse?) in
                print("upload error: \(error)")
                completion()
        })
    }
    
    func createJSONfromObject(obj:T)->NSMutableDictionary{
        var json = NSMutableDictionary()
        for name in propertyNames() {
            if let value: AnyObject = (obj as NSManagedObject).valueForKey(name) {
                json[camelToSnake(name)] = value
            }
        }
        return json
    }
    
    func propertyNames() -> [String] {
        var names: [String] = []
        var count: UInt32 = 0
        // Uses the Objc Runtime to get the property list
        let properties = class_copyPropertyList(T.self, &count)
        for var i = 0; i < Int(count); i += 1 {
            let property: objc_property_t = properties[i]
            let name: String =
            NSString(CString: property_getName(property), encoding: NSUTF8StringEncoding)! as String
            names.append(name)
        }
        free(properties)
        return names
    }
    
    func downloadNew(completion:(()->()) = {}){
        var since = 0
        if let newest = all().last {
            since = (newest as NSManagedObject).valueForKey("id") as! Int
        }
        var request = HTTPTask()
        request.GET(url,
            parameters: ["since" : since],
            success: { (response: HTTPResponse) in
                if response.responseObject != nil {
                    if let data = response.responseObject as? NSData {
                        self.addJSONToSql(JSONDecoder(data))
                        // Get back on main thread for view updates
                        dispatch_async(dispatch_get_main_queue()) {
                            completion()
                        }
                    }
                }
            },
            failure: nil
        )
    }

    func addJSONToSql(decoderArray: JSONDecoder) {
        for decoder in decoderArray.array! {
            if all().find(decoder["id"].integer as Int!) == nil {
                createObjectFromJSON(decoder)
            }
        }
        do {
            try db!.save()
        } catch _ {
        }
    }
    
    func createObjectFromJSON(decoder: JSONDecoder){
        var object = NSEntityDescription.insertNewObjectForEntityForName(self.entityName, inManagedObjectContext: self.db!) as! T
        if let desc = self.entityDescription {
            for attribute in desc.attributesByName {
                let name = attribute.0 as String
                let decoderName = camelToSnake(name)
                let attr = attribute.1 as NSAttributeDescription
                switch attr.attributeType {
                case .StringAttributeType:
                    let value = decoder[decoderName].string as String!
                    (object as NSManagedObject).setValue(value, forKey: name)
                case .Integer64AttributeType:
                    let value = decoder[decoderName].integer as Int!
                    (object as NSManagedObject).setValue(value, forKey: name)
                default:
                    print("Oops")
                }
            }
        }
    }
    
    func newObj()->T{
        return NSEntityDescription.insertNewObjectForEntityForName(self.entityName, inManagedObjectContext: self.db!) as! T
    }

    func save(){
        do {
            try db!.save()
        } catch _ {
        }
        
    }
    
    func camelToSnake(attribute:String)->String{
        // I would love to do this whole thing functionally, but swift's map is broken with characters
        let arr = attribute.characters.map { String($0) }
        var str = ""
        for letter in arr {
            if letter == letter.capitalizedString {
                str += "_\(letter.lowercaseString)"
            } else
            {
                str += letter
            }
        }
        return str
    }
    
    func snakeToCamel(attribute:String)->String{
        var splitString = attribute.componentsSeparatedByString("_")
        let firstString = splitString.removeAtIndex(0)
        var capitalizedString = splitString.map({string in string.uppercaseString})
        capitalizedString.insert(firstString, atIndex: 0)
        return capitalizedString.joinWithSeparator("")
    }
}
