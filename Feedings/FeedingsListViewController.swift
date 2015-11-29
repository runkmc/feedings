//
//  FeedingsListViewController.swift
//  Feedings
//
//  Created by Kevin McGladdery on 11/24/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit
import Parse

class FeedingsListViewController: UIViewController {
  
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        guard let currentUser = PFUser.currentUser() else {
            performSegueWithIdentifier("showLoginController", sender: self)
            return
        }
    }
    
    @IBAction func unwindWithSignup(segue: UIStoryboardSegue) {
        
    }

}
