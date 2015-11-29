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
        loginButton.backgroundColor = UIColor.darkGrayColor()
        loginButton.layer.cornerRadius = 24
        signupButton.layer.cornerRadius = 24
        
        usernameField.underline(UIColor.init(hex: 0xD5D5D5FF))
        passwordField.underline(UIColor.init(hex: 0xD5D5D5FF))
        
        combineLatest(usernameField.bnd_text, passwordField.bnd_text).map {
            name, pass in
            return name?.characters.count > 0 && pass?.characters.count > 0
        }.bindTo(loginButton.bnd_enabled)
        
        loginButton.bnd_enabled.observe { event in
            if event {
                self.loginButton.backgroundColor = UIColor.feedingsBlue
            } else {
                self.loginButton.backgroundColor = UIColor.darkGrayColor()
            }
        }
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
