//
//  SignupViewController.swift
//  Feedings
//
//  Created by Kevin McGladdery on 11/25/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController {

    @IBOutlet weak var signupButton: HighlightedButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        signupButton.layer.cornerRadius = 24
      
        let bottomUsernameBorder = CALayer()
        bottomUsernameBorder.frame = CGRectMake(0.0, usernameField.frame.size.height - 1, usernameField.frame.size.width, 1.0)
        bottomUsernameBorder.backgroundColor = UIColor.init(hex: 0xD5D5D5FF).CGColor
        usernameField.layer.addSublayer(bottomUsernameBorder)
        let bottomPasswordBorder = CALayer()
        bottomPasswordBorder.frame = CGRectMake(0.0, usernameField.frame.size.height - 1, usernameField.frame.size.width, 1.0)
        bottomPasswordBorder.backgroundColor = UIColor.init(hex: 0xD5D5D5FF).CGColor
        passwordField.layer.addSublayer(bottomPasswordBorder)
        let bottomEmailBorder = CALayer()
        bottomEmailBorder.frame = CGRectMake(0.0, usernameField.frame.size.height - 1, usernameField.frame.size.width, 1.0)
        bottomEmailBorder.backgroundColor = UIColor.init(hex: 0xD5D5D5FF).CGColor
        emailField.layer.addSublayer(bottomEmailBorder)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupUser(sender: AnyObject) {
        indicator.startAnimating()
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        user.email = emailField.text
        
        user.signUpInBackgroundWithBlock {(succeeded: Bool, error: NSError?) -> Void in
            self.indicator.stopAnimating()
            if let signupError = error {
                let errorString = signupError.userInfo["error"] as? String
                let alert = UIAlertController.init(title: "Problem with Signup", message: errorString, preferredStyle: .Alert)
                let action = UIAlertAction.init(title: "Ok", style: .Default, handler:nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
            
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
