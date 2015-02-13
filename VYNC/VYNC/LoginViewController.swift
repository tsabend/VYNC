//
//  LoginViewController.swift
//  VYNC
//
//  Created by Thomas Abend on 2/2/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController, FBLoginViewDelegate {
    
    @IBOutlet var fbLoginView : FBLoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
    }
    
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RootNavigationController") as! UINavigationController
        presentViewController(vc, animated: true, completion: {})
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){

        let fbId = user.objectID as String
        if myUserId() == nil {
            FBRequestConnection.startForMeWithCompletionHandler{(connection, user, error) -> Void in
                println("Adding user")
                let email = user.objectForKey("email") as! String
                // new User object
                var newUser = User.syncer.newObj()
                newUser.id = 0
                newUser.username = user.name
                newUser.facebookObjectId = fbId
                newUser.isMe = 1
                newUser.email = email
                User.syncer.save()
                User.syncer.sync()
            }
        }
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println(UIScreen.mainScreen().bounds)
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}