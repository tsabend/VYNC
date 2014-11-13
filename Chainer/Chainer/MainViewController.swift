import UIKit
import CoreMedia
import CoreData
import MobileCoreServices
import AVKit
import AVFoundation

let s3Url = "https://s3-us-west-2.amazonaws.com/telephono/"
let docFolderToSaveFiles = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
let fileName = "/videoToSend.MOV"
let PathToFile = docFolderToSaveFiles + fileName
let unlockUrl : String = "https://s3-us-west-2.amazonaws.com/telephono/IMG_0370.MOV"










class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblChains: UITableView!

    var chains = [[VideoMessage]]()
    var urlsToPlay : [String] = []
    var replyToID : Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoMessageMgr.view = self
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "showCam")
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "onSwipe")
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
    }
        // Load the table view
    func onModelUpdate(model: Videos) {
        chains = model.asChains().reverse()
        tblChains.reloadData()
    }


    // Returning to view. Loops through users and reloads them.
    override func viewWillAppear(animated: Bool) {
        onModelUpdate(videoMessageMgr)
        super.viewWillAppear(animated)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        
        
        let sentID = self.chains[indexPath.row].first!.senderID
        
        println(sentID)
        let usersArray = userMgr.asUsers()
//        println(find(userMgr.asUsers(), $0.userID == 26 ))
        let sendingUser = usersArray.filter({$0.userID == 9 as NSNumber })
        
        println("sent from: \(usersArray.first?.userID)")
        println("sent from: \(sendingUser.first?.username)")
        
        
        
        let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(210, 16,
            100,
            CGRectGetHeight(cell.bounds))
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Reply", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.AllEvents)
        button.layer.cornerRadius = 14

        cell.addSubview(button)
        
        cell.textLabel.text = "Chain in reply to: \(chains[indexPath.row].first!.replyToID)"
        cell.detailTextLabel?.text = "Length: \(chains[indexPath.row].count)"
        return cell
    }
    
    func buttonAction(sender:UIButton!)
    {
        println("Button tapped")
        self.showCam()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chains.count
    }

//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
//        let moreClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
//            self.replyToID = self.chains[indexPath.row].first!.replyToID as? Int
//            self.showCam()
//        }
//
//        let moreAction = UITableViewRowAction(style: .Normal, title: "Reply", handler: moreClosure)
//        
//        return [moreAction]
//    }
    
//    //necessary function for reply button
//   func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//
//    }
    
    @IBAction func onSwipe(sender: UISwipeGestureRecognizer) {
        videoMessageMgr.update()
        println("Hello world")
    }
    @IBAction func showCam() {
        let imagePicker = UIImagePickerController() //inst
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera // Set the media type to allow movies
        imagePicker.mediaTypes = [kUTTypeMovie] // Maximum length 6 seconds
        imagePicker.videoMaximumDuration = 5.00
        self.presentViewController(imagePicker, animated: false, completion:{})
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        picker.dismissViewControllerAnimated(false, completion: {})
        
        //save the video that the user records
        let fileUrl = info[UIImagePickerControllerMediaURL] as? NSURL
        var myVideo : NSData = NSData(contentsOfURL: fileUrl!)!
        var boolean = myVideo.writeToFile(PathToFile, atomically: true)
        
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Contacts") as ContactsViewController
        vc.replyToID = self.replyToID
        self.presentViewController(vc, animated:false, completion:{
            self.replyToID = 0
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var userID = NSString(data: theFileManager.contentsAtPath(pathToUserFile)!, encoding: NSUTF8StringEncoding) as String
        if chains[indexPath.row].first?.recipientID == userID.toInt()! {
            // display only the most recent video in chain
            urlsToPlay = [s3Url + chains[indexPath.row].first!.videoID]
            urlsToPlay.append(unlockUrl)
            playVidUrlOnViewController(urlsToPlay, self)
        } else {
            // display the whole the chain
            urlsToPlay = [String]()
            urlsToPlay = map(chains[indexPath.row], { s3Url + $0.videoID}).reverse()
            playVidUrlOnViewController(urlsToPlay, self)
        }
    }
}

