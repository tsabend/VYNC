//
//  AR.swift
//  VYNC
//
//  Created by Thomas Abend on 1/29/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Assumes that primaryKey is id
class AR<T : NSManagedObject> {
    
    let req : NSFetchRequest!
    
    lazy var db : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
    }()
    
    var first:T? {
        get {
            return exec()!.first
        }
    }
    
    var last:T? {
        get {
            return exec()!.last
        }
    }
    
    init() {
        let entityName = getName(T)
        self.req = NSFetchRequest()
        req.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.db!)
        req.propertiesToFetch = req.entity?.properties
    }
    
    func sortBy(key: String, ascending: Bool) -> AR<T> {
        if req.sortDescriptors == nil {
            req.sortDescriptors = [NSSortDescriptor(key: key, ascending: ascending)]
        } else {
            req.sortDescriptors?.append(NSSortDescriptor(key: key, ascending: ascending))
        }
        return self
    }
    
    func limit(count: Int) -> AR<T> {
        req.fetchLimit = count
        return self
    }
    
    func exec() -> [T]? {
        var error: NSError?
        if let results = db!.executeFetchRequest(req, error: &error) as? [T] {
            return results
        }
        return nil
    }
    
    func filter(format:String, args:AnyObject...)->AR<T> {
        req.predicate = NSPredicate(format: format, argumentArray: args)
        return self
    }
    
    func find(id:Int)->AR<T> {
        return filter("id == %@", args: id).limit(1)
    }
    
}
