//
//  LoginViewController.swift
//  Feedings
//
//  Created by Kevin McGladdery on 11/25/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit
import Bond

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var notRegisteredLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        notRegisteredLabel.text = NSLocalizedString("Not registered?", comment: "")
        loginButton.setTitle(NSLocalizedString("Log in", comment: ""), for: UIControlState())
        loginButton.backgroundColor = UIColor.darkGray
        loginButton.layer.cornerRadius = 24
        signupButton.setTitle(NSLocalizedString("Sign up", comment: ""), for: UIControlState())
        signupButton.layer.cornerRadius = 24
        
        usernameField.placeholder = NSLocalizedString("username", comment: "")
        passwordField.placeholder = NSLocalizedString("password", comment: "")
        
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
    
    @IBAction func loginTapped(_ sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if let _ = user {
                self.performSegueWithIdentifier("unwindFromSignup", sender: self)
            }
            if let loginError = error {
                let errorString = loginError.userInfo["error"] as? String
                let alert = UIAlertController.init(title: NSLocalizedString("Problem with Login", comment: ""), message: errorString, preferredStyle: .Alert)
                let action = UIAlertAction.init(title: "Ok", style: .Default, handler:nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func forgotPassword(_ sender: AnyObject) {
        let alert = UIAlertController.init(title: NSLocalizedString("Forgot password?", comment: ""), message: NSLocalizedString("Enter your email to recieve a password reset link", comment: ""),preferredStyle: .alert)
        alert.addTextField {
            textField in
            textField.font = UIFont(name: "FiraSans-Book", size: 12)!
        }
        let cancel = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler:nil)
        alert.addAction(cancel)
        let send = UIAlertAction.init(title: NSLocalizedString("Reset Password", comment: ""), style: .default, handler: {
            action in
            if let email = alert.textFields?[0].text {
                PFUser.requestPasswordResetForEmailInBackground(email)
            }
        })
        alert.addAction(send)
        self.present(alert, animated: true, completion:nil)
    }
    
    @IBAction func backgroundTapped(_ sender: AnyObject) {
        view.endEditing(true)
    }
}
