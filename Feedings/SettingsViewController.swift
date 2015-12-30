//
//  SettingsViewController.swift
//  Feedings
//
//  Created by Kevin McGladdery on 11/27/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit
import Colortools
import Parse

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: HighlightedButton!
    
    override func viewDidLoad() {
        logoutButton.setTitle(NSLocalizedString("Logout", comment: ""), forState: .Normal)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutTapped(sender: AnyObject) {
        let query = PFQuery(className: "Feeding")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error:NSError?) -> Void in
            PFObject.unpinAllInBackground(objects)
            PFUser.logOutInBackground()
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
