//
//  ContactsViewController.swift
//  VYNC
//
//  Created by Thomas Abend on 1/25/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import Foundation
import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var contacts = allUsers
    var filteredUsers = [User]()
    var replyToID : Int = 0
    var vyncTitle : String?

    @IBOutlet var contactsList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsList.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITableViewDataSource requirements
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "test")
        
        cell.imageView?.image = UIImage(named: "envelope")
        
        var user : User
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            user = filteredUsers[indexPath.row]
        } else {
            user = contacts[indexPath.row]
        }
        
        cell.textLabel?.text = "\(user.username)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return filteredUsers.count
        } else {
            return contacts.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(self.replyToID)
        println(self.vyncTitle)
        performSegueWithIdentifier("backToHome", sender: self)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredUsers = self.contacts.filter({( user : User) -> Bool in
            var nameMatch = (scope == "All") || (user.username == scope)
            var stringMatch = user.username.lowercaseString.rangeOfString(searchText.lowercaseString)
            return nameMatch && (stringMatch != nil)
        })
    }
    //MARK: - UISearchBarDelegate
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString.lowercaseString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!,
        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
            self.filterContentForSearchText(self.searchDisplayController!.searchBar.text.lowercaseString)
            return true
    }
}