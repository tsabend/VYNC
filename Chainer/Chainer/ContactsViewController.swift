//
//  SecondViewController.swift
//  viewAllUsers
//
//  Created by Apprentice on 11/8/14.
//  Copyright (c) 2014 Apprentice. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblUsers: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Returning to view. Loops through users and reloads them.
    override func viewWillAppear(animated: Bool) {
        tblUsers.reloadData()
    }
    
    // UITableViewDataSource requirements
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.textLabel.text = "User Id: \(userMgr.users[indexPath.row].userID)"
        cell.detailTextLabel?.text = "Device Id: \(userMgr.users[indexPath.row].deviceID). Created at \(userMgr.users[indexPath.row].createdAt)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMgr.users.count
    }
    
    // UITableViewDelegateFunctions: These are to help launch events from the table view
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            userMgr.users.removeAtIndex(indexPath.row)
            tblUsers.reloadData()
        }
    }
    
    // Print hello world when clicked
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("anyone listening?")
        let userID = userMgr.users[indexPath.item].userID as Int!
        var request = HTTPTask()
        request.GET("http://localhost:9393/users/\(userID)", parameters: nil, success: {(response: HTTPResponse) in // success
            if response.responseObject != nil {
                let data = response.responseObject as NSData
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                println(str)
            }
            },failure: {(error: NSError, response: HTTPResponse?) in //failure
                println("error: \(error)")
        })
    }
    
    
}

