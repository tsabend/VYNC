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
    var window: UIWindow?
    
    var email : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
    }
    
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        //        println("This is where you perform a segue.")

        var newUser = User.syncer.newObj()
        newUser.id = 0
        newUser.username = "test"
                newUser.is_me = true
        User.syncer.save()
        User.syncer.sync()
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RootNavigationController") as UINavigationController
        presentViewController(vc, animated: true, completion: {})
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        println("User Name: \(user.name)")
        println("User ObjectID: \(user.objectID)")
                FBRequestConnection.startForMeWithCompletionHandler{(connection, user, error) -> Void in
                    self.email = user.objectForKey("email") as String
                            println("User Email: \(self.email)")
                    self.performSegueWithIdentifier("showRoot", sender: self)
        
                }
        
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}