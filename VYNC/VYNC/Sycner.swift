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
    
    init(url:String) {
        self.url = url
        self.entityName = getName(T)
        self.entityDescription = NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: self.db!)
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
    
    func all() -> AR<T> {
        return AR<T>()
    }
    
    // HTTP Functions
    func sync() {
        downloadNew()
        uploadNew()
    }
    
    func uploadNew(){
        // post the video that the user takes to the server
        var request = HTTPTask()
        let newObjs = all().filter("id == %@", args: 0).exec()!
        for obj in newObjs {
            let json = createJSONfromObject(obj)
            request.POST(url, parameters: ["json": json],
                success: {(response: HTTPResponse) in
                    if let data = response.responseObject as? NSData {
                        let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("upload response: \(str!)") //prints the response
                    }
                    
                },failure: {(error: NSError, response: HTTPResponse?) in
                    println("error: \(error)")
            })
        }
    }
    
    func createJSONfromObject(obj:T)->NSMutableDictionary{
        var json = NSMutableDictionary()
        for name in propertyNames() {
            if let value: AnyObject = obj.valueForKey(name) {
                json[name] = value
            }
        }
        return json
    }
    
    func propertyNames() -> [String] {
        var names: [String] = []
        var count: UInt32 = 0
        // Uses the Objc Runtime to get the property list
        var properties = class_copyPropertyList(T.self, &count)
        for var i = 0; i < Int(count); ++i {
            let property: objc_property_t = properties[i]
            let name: String =
            NSString(CString: property_getName(property), encoding: NSUTF8StringEncoding)!
            names.append(name)
        }
        free(properties)
        return names
    }
    
    func downloadNew(){
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
                        self.addJSONToSql(JSONDecoder(data))
                    }
                }
        })
    }

    func addJSONToSql(decoderArray: JSONDecoder) {
        for decoder in decoderArray.array! {
            if all().find(decoder["id"].integer as Int!).first == nil {
                createObjectFromJSON(decoder)
            }
        }
        db!.save(nil)
    }
    
    func createObjectFromJSON(decoder: JSONDecoder){
        var object = NSEntityDescription.insertNewObjectForEntityForName(self.entityName, inManagedObjectContext: self.db!) as T
        if let desc = self.entityDescription {
            for attribute in desc.attributesByName {
                let name = attribute.0 as String
                let decoderName = camelToSnake(name)
                let attr = attribute.1 as NSAttributeDescription
                switch attr.attributeType {
                case .StringAttributeType:
                    let value = decoder[decoderName].string as String!
                    object.setValue(value, forKey: name)
                case .Integer64AttributeType:
                    let value = decoder[decoderName].integer as Int!
                    object.setValue(value, forKey: name)
                default:
                    println("Oops")
                }
            }
        }
    }
    
    func newObj()->T{
        return NSEntityDescription.insertNewObjectForEntityForName(self.entityName, inManagedObjectContext: self.db!) as T
    }

    func save(){
        db!.save(nil)
    }
    
    func camelToSnake(attribute:String)->String{
        // I would love to do this whole thing functionally, but swift's map is broken with characters
        var arr = map(attribute) { String($0) }
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
        var splitString = split(attribute) {$0 == "_"} as [String]
        var firstString = splitString.removeAtIndex(0)
        var capitalizedString = splitString.map({string in string.uppercaseString})
        capitalizedString.insert(firstString, atIndex: 0)
        return join("", capitalizedString)
    }
}

