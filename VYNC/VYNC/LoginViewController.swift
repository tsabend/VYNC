//
//  LoginViewController.swift
//  VYNC
//
//  Created by Thomas Abend on 2/2/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {

    
    @IBAction func signUp(sender: AnyObject) {
        var newUser = User.syncer.newObj()
        newUser.id = 0
        newUser.username = "test"
        newUser.is_me = true
        User.syncer.save()
        User.syncer.sync()
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RootNavigationController") as UINavigationController
        presentViewController(vc, animated: true, completion: {})
    }

}