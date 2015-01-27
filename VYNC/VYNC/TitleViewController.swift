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


    @IBOutlet weak var vyncTitle: UITextField!
    @IBAction func submit(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
