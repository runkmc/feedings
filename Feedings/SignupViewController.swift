//
//  SignupViewController.swift
//  Feedings
//
//  Created by Kevin McGladdery on 11/25/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit
import Parse
import Bond

class SignupViewController: UIViewController {

    @IBOutlet weak var signupButton: HighlightedButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: HighlightedButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        signupButton.layer.cornerRadius = 24
        cancelButton.layer.cornerRadius = 24
        signupButton.enabled = false
        self.signupButton.backgroundColor = UIColor.darkGrayColor()
        
        signupButton.bnd_enabled.observe {enabled in
            if enabled {
                self.signupButton.backgroundColor = UIColor.feedingsBlue
            } else {
                self.signupButton.backgroundColor = UIColor.darkGrayColor()
            }
        }
        
        combineLatest(usernameField.bnd_text, passwordField.bnd_text, emailField.bnd_text)
            .map {name, pass, email in
                return (name?.characters.count > 0) && (pass?.characters.count > 0) && (email?.characters.count > 0)
        }.bindTo(signupButton.bnd_enabled)
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
                let alert = UIAlertController.init(title: NSLocalizedString("Problem with Signup", comment: ""), message: errorString, preferredStyle: .Alert)
                let action = UIAlertAction.init(title: "Ok", style: .Default, handler:nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.performSegueWithIdentifier("unwindFromSignup", sender: self)
            }
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
