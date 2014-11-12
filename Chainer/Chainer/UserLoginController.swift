//
//  userLoginController.swift
//  Chainer
//
//  Created by Apprentice on 11/10/14.
//  Copyright (c) 2014 DBC. All rights reserved.
//

import Foundation
import UIKit

class UserLoginController: UIViewController {
    
    
    
    @IBOutlet weak var usernameTxt: UITextField!
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func signUp(sender: AnyObject) {
        var deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
        if usernameTxt.text == "" {
            displayAlert("Error In Form", error: "Please fill in all fields")
        } else {
            var request = HTTPTask()
            let params: Dictionary<String,AnyObject!> = ["deviceId": deviceId, "username": usernameTxt.text, "devicetoken": currentUser.deviceToken!]
            request.POST("http://chainer.herokupapp.com/newuser", parameters: params, success: {(response: HTTPResponse) in
                if response.responseObject != nil {
                    print("success")
                }
                } ,failure: {(error: NSError, response: HTTPResponse?) in
                    println("failure")
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    override func viewDidLoad() {

        super.viewDidLoad()
        
    }
    override func viewDidAppear(animated: Bool) {
        
    }
}