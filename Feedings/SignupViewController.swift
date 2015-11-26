//
//  SignupViewController.swift
//  Feedings
//
//  Created by Kevin McGladdery on 11/25/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var signupButton: HighlightedButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
  
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
