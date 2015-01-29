//
//  TitleViewController.swift
//  VYNC
//
//  Created by Thomas Abend on 1/26/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import UIKit

class TitleViewController : UIViewController, UITextFieldDelegate {
    var replyToId: Int = 0

    @IBOutlet weak var vyncTitle: UITextField!

    
    @IBOutlet weak var charsLeft: UILabel!
    

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = countElements(textField.text!) + countElements(string) - range.length
        charsLeft.text = "\(30 - newLength)"
        return newLength < 30 //Bool
    }
    
    @IBAction func submit(sender: AnyObject) {
        let contactsNav = self.storyboard?.instantiateViewControllerWithIdentifier("ContactsNav") as UINavigationController
        let contacts = contactsNav.viewControllers[0] as ContactsViewController
        contacts.replyToId = self.replyToId
        contacts.vyncTitle = vyncTitle.text
        self.presentViewController(contactsNav, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vyncTitle.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
