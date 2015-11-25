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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loginButton.layer.cornerRadius = 24
    signupButton.layer.cornerRadius = 24
    
    let bottomUsernameBorder = CALayer()
    bottomUsernameBorder.frame = CGRectMake(0.0, usernameField.frame.size.height - 1, usernameField.frame.size.width, 1.0)
    bottomUsernameBorder.backgroundColor = UIColor.init(hex: 0xD5D5D5FF).CGColor
    usernameField.layer.addSublayer(bottomUsernameBorder)
    let bottomPasswordBorder = CALayer()
    bottomPasswordBorder.frame = CGRectMake(0.0, usernameField.frame.size.height - 1, usernameField.frame.size.width, 1.0)
    bottomPasswordBorder.backgroundColor = UIColor.init(hex: 0xD5D5D5FF).CGColor
    passwordField.layer.addSublayer(bottomPasswordBorder)
  }
}
