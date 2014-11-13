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
        
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "onSwipe")
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
        // Your user id, from that file we made
        var userID = NSString(data: theFileManager.contentsAtPath(pathToUserFile)!, encoding: NSUTF8StringEncoding) as String

        // conditional links vs. link
        var link = "VYNCs"
        if chains[indexPath.row].count == 1 {
            link = "VYNC"
        }
        
        // The id of the person who sent you this video.
        let sentID = self.chains[indexPath.row].first!.senderID
        let recipientID = self.chains[indexPath.row].last!.recipientID
        // The username of the person who sent you this video.
        let usersArray = userMgr.asUsers()
        var sendingUser = usersArray.filter({$0.userID == sentID as NSNumber }).first?.username
        
        
        // The date of the most recent message on the chain.
        //  var updatedDate = self.chains[indexPath.row].last!.createdAt
        //  println(updatedDate)

        // Hack to use the current date because active record is sending back annoying dates at the moment.
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateFormat = "MMMM d"
        let stringDate = formatter.stringFromDate(date)
        
        if recipientID == userID.toInt()! {                               // if you are holding up the chain
            let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
            button.frame = CGRectMake(250, 0, 78, 78)
//            button.backgroundColor = UIColor.greenColor()
            button.setTitle("VYNC", forState: UIControlState.Normal)
            button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchDown)
//            button.alpha = 0.2
//            button.layer.cornerRadius = 156
            cell.addSubview(button)
            cell.textLabel.text = "\(sendingUser!)"
            cell.detailTextLabel?.text = "\(chains[indexPath.row].count) \(link) long. \(stringDate)"
        } else if sentID == userID.toInt()! {                                           // if you sent the message
            cell.textLabel.text = "Following"
            cell.detailTextLabel?.text = "\(chains[indexPath.row].count) \(link) long. \(stringDate)"
        } else {                                                        // if you are just following
            cell.textLabel.text = "Following \(sendingUser!)"
            cell.detailTextLabel?.text = "\(chains[indexPath.row].count) \(link) long. \(stringDate)"
        }
        return cell
    }
    
    func buttonAction(sender:UIButton!)
    {
        self.showCam()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chains.count
    }

    @IBAction func onSwipe() {
        videoMessageMgr.update()
    }
    @IBAction func showCam() {
        let imagePicker = UIImagePickerController() //inst
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera // Set the media type to allow movies
        imagePicker.mediaTypes = [kUTTypeMovie] // Maximum length 6 seconds
        imagePicker.videoMaximumDuration = 6.00
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

