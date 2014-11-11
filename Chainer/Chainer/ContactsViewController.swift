
//  Created by Apprentice on 11/8/14.
//  Copyright (c) 2014 Apprentice. All rights reserved.
//

import UIKit


class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

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
    
    // Sending a video message to a user
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let videoURL = NSURL(string: PathToFile)
        let userID = userMgr.users[indexPath.item].userID as Int!
        //post the video that the user takes to the server
        var request = HTTPTask()
        request.POST("http://chainer.herokuapp.com/upload", parameters:  ["sender": "1", "recipient" : "\(userID)",  "file": HTTPUpload(fileUrl: videoURL!) ], success: {(response: HTTPResponse) in
                if let data = response.responseObject as? NSData {
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("response from upload: \(str)") //prints the HTML of the page
                }
            
            },failure: {(error: NSError, response: HTTPResponse?) in
                //error out on stuff
        })
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Home") as ViewController
        self.presentViewController(vc, animated:false, completion:{})
    }
    
    
}

