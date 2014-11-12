//
//  OnStartUp.swift
//  viewAllUsers
//
//  Created by Apprentice on 11/9/14.
//  Copyright (c) 2014 Apprentice. All rights reserved.
//

import Foundation
import CoreData

let videoMessageMgr = Videos()
let device_id = 1//UIDevice.currentDevice().identifierForVendor.UUIDString

func onStartup() {
    userMgr.getUsers()
    videoMessageMgr.update()
}
