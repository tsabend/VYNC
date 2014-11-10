////
////  Users.swift
////  viewAllUsers
////
////  Created by Apprentice on 11/8/14.
////  Copyright (c) 2014 Apprentice. All rights reserved.
////
//
import Foundation
import UIKit

struct User : JSONJoy {
    var userID: Int?
    var deviceID: Int?
    var createdAt: String?
    
    init(_ decoder: JSONDecoder) {
        userID = decoder["id"].integer
        deviceID = decoder["device_id"].integer
        createdAt = decoder["created_at"].string
    }
    
}


struct UsersArray : JSONJoy {
    var users : [User] = []
    
    init(_ decoder: JSONDecoder) {
        if let usrs = decoder["users"].array {
            users = [User]()
            for usrDecoder in usrs {
                users.append(User(usrDecoder))
            }
        }
    }
}


class UserManager {
    var users = [User]()

    func getUsers(){
        println("getting all users")
        var request = HTTPTask()
        request.GET("http://localhost:9393/allusers", parameters: nil, success: {(response: HTTPResponse) in // success
        if response.responseObject != nil {
        let data = response.responseObject as NSData
        let str = NSString(data: data, encoding: NSUTF8StringEncoding)
        userMgr.parseUserFromGetRequest(data)
        }
        },failure: {(error: NSError, response: HTTPResponse?) in //failure
        println("error: \(error)")
        })
    }
    
    func parseUserFromGetRequest(data : NSData) {
        var usersArray = UsersArray(JSONDecoder(data))
        for user in usersArray.users {
            self.users.append(user)
        }
    }
    
}

let userMgr = UserManager()