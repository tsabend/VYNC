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
        deviceID = decoder["deviceId"].integer
        createdAt = decoder["created_at"].string
    }
}

class UserManager {
    var users = [User]()

    func getUsers(){
        println("getting all users")
        var request = HTTPTask()
        request.GET("http://chainer.herokuapp.com/allusers", parameters: nil, success: {
            (response: HTTPResponse) in // success
            if response.responseObject != nil {
                let data = response.responseObject as NSData
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                JSONDecoder(data).arrayOf(&self.users)
                println("get all users safely returned: \(str)")
            }
        },failure: {(error: NSError, response: HTTPResponse?) in //failure
            println("error: \(error)")
        })
    }
}

let userMgr = UserManager()

class globalUser {
    var deviceToken : String? = ""
    init(){
    }
}

let currentUser = globalUser()