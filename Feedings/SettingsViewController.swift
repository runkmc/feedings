//
//  SettingsViewController.swift
//  Feedings
//
//  Created by Kevin McGladdery on 11/27/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: HighlightedButton!
    
    override func viewDidLoad() {
        logoutButton.setTitle(NSLocalizedString("Logout", comment: ""), for: UIControlState())
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutTapped(_ sender: AnyObject) {
        let logoutClosure = {
        (alert:UIAlertAction) -> Void in
        let query = PFQuery(className: "Feeding")
        let defaults = UserDefaults.standard
        defaults.set(Date.distantPast, forKey: "lastUpdated")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error:NSError?) -> Void in
            PFObject.unpinAllInBackground(objects) {
                (success:Bool, error:NSError?) -> Void in
                PFUser.logOut()
                print("logout called")
                self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        }
        let alert = UIAlertController.init(title: NSLocalizedString("Logout?", comment: ""), message: "Are you sure?", preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler:nil)
        let logout = UIAlertAction.init(title: "Logout", style: .destructive, handler:logoutClosure)
        alert.addAction(cancel)
        alert.addAction(logout)
        self.present(alert, animated: true, completion:nil)
    }
}
