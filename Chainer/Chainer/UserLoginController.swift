import Foundation
import UIKit

class UserLoginController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var usernameTxt: UITextField!
    
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUp(sender: AnyObject) {
        var activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        func createFileAtPath
        var deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
        if usernameTxt.text == "" {
            displayAlert("Error In Form", error: "Please enter a username")
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
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Home") as ViewController
        self.presentViewController(vc, animated:false, completion:{})
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        if  {
            self.performSegueWithIdentifier("jumpToNewChains", sender: self)
        }
    }
}