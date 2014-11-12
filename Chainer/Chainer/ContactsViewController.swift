
//  Created by Apprentice on 11/8/14.
//  Copyright (c) 2014 Apprentice. All rights reserved.
//

import UIKit


class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet var tblUsers: UITableView!
    @IBOutlet var searchBar : UISearchBar!

    var users = [User]()
    var filteredUsers = [User]()
    
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
        users = userMgr.asUsers()
        tblUsers.reloadData()

    }
    
    // UITableViewDataSource requirements
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        
        var user : User
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        
        cell.textLabel.text = "Username: \(user.username)"
        cell.detailTextLabel?.text = "User Id: \(user.userID))"
        cell.imageView.image = UIImage(contentsOfFile :"/Users/apprentice/Documents/thomas/chainer/Chainer/Chainer/Zinc-Chain.jpg")
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return filteredUsers.count
        } else {
            return users.count
        }
    }
    
    // UITableViewDelegateFunctions: These are to help launch events from the table view
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
    
    // Sending a video message to a user
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let videoURL = NSURL(string: PathToFile)
        let userID = users[indexPath.item].userID
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
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredUsers = self.users.filter({( user : User) -> Bool in
            var categoryMatch = (scope == "All") || (user.username == scope)
            var stringMatch = user.username.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    //MARK: - UISearchBarDelegate
    //not quite working...
//    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
//        let scopes = self.searchBar.scopeButtonTitles as [String]
//        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
//        self.filterContentForSearchText(searchString, scope: selectedScope)
//        return true
//    }
//    
//    func searchDisplayController(controller: UISearchDisplayController!,
//        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
//        let scope = self.searchBar.scopeButtonTitles as [String]
//        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
//        return true
//    }
    
}

