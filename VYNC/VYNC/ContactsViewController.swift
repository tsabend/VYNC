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
    
    var contacts = User.syncer.all().filter("isMe == nil").exec()!
    var filteredUsers = [User]()
    var replyToId : Int = 0
    var vyncTitle : String?

    @IBOutlet var contactsList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        for user in contacts {
            print("User\(user.id)\n \(user.username)\n")
        }
        super.viewDidLoad()
        contactsList.reloadData()
        contactsList.setNeedsDisplay()
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
            user = contacts[indexPath.row] as User
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
        let recipientId = contacts[indexPath.row].id
        
        let data = NSData(contentsOfFile: pathToFile)
        let videoId = NSUUID().UUIDString + ".mov"
        let newFilePath = docFolderToSaveFiles + "/" + videoId
        data?.writeToFile(newFilePath, atomically: true)
        
        if self.replyToId != 0 {
            print("making a reply \(replyToId)")
            _ = VideoMessage.asVyncs().filter({vync in vync.replyToId() == self.replyToId})[0]

            let newMessage = VideoMessage.syncer.newObj()
            newMessage.id = 0
            newMessage.videoId = videoId
            newMessage.replyToId = replyToId
            newMessage.recipientId = recipientId
            newMessage.senderId = myUserId()
            newMessage.title = ""
            newMessage.saved = 1
            VideoMessage.syncer.save()

        } else {
            let newMessage = VideoMessage.syncer.newObj()
            newMessage.id = 0
            newMessage.videoId = videoId
            // but what if you have more than one 0? This is broken as is.
            newMessage.replyToId = 0
            newMessage.recipientId = recipientId
            newMessage.senderId = myUserId()
            newMessage.title = self.vyncTitle!
            newMessage.saved = 1
            VideoMessage.syncer.save()
        }
        performSegueWithIdentifier("backToHome", sender: self)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredUsers = self.contacts.filter({( user : User) -> Bool in
            let nameMatch = (scope == "All") || (user.username == scope)
            let stringMatch = user.username.lowercaseString.rangeOfString(searchText.lowercaseString)
            return nameMatch && (stringMatch != nil)
        })
    }
    
    //MARK: - UISearchBarDelegate
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.filterContentForSearchText(searchString!.lowercaseString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController,
        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
            self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!.lowercaseString)
            return true
    }
}