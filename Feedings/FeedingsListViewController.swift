//
//  FeedingsListViewController.swift
//  Feedings
//
//  Created by Kevin McGladdery on 11/24/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit
import Parse
import DZNEmptyDataSet

class FeedingsListViewController: UIViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    var currentUser: PFUser?
  
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        guard let user = PFUser.currentUser() else {
            performSegueWithIdentifier("showLoginController", sender: self)
            return
        }
        self.currentUser = user
    }
    
    @IBAction func unwindFromAddingFeeding(sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromSignup(sender: UIStoryboardSegue) {
        
    }
}
