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
  }
}
