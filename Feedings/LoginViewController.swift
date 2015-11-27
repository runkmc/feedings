//
//  LoginViewController.swift
//  Feedings
//
//  Created by Kevin McGladdery on 11/25/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit
import Bond
import Colortools
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 24
        signupButton.layer.cornerRadius = 24
        
        usernameField.underline(UIColor.init(hex: 0xD5D5D5FF))
        passwordField.underline(UIColor.init(hex: 0xD5D5D5FF))
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if let _ = user {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            if let loginError = error {
                let errorString = loginError.userInfo["error"] as? String
                let alert = UIAlertController.init(title: "Problem with Login", message: errorString, preferredStyle: .Alert)
                let action = UIAlertAction.init(title: "Ok", style: .Default, handler:nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
                
        }
    }
    
}
