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
import Bond

class FeedingsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var currentUser: PFUser?
    var day = Day(feedings: [])
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "FiraSans-Medium", size: 20)!, NSForegroundColorAttributeName: UIColor.feedingsOrange]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        guard let user = PFUser.currentUser() else {
            performSegueWithIdentifier("showLoginController", sender: self)
            return
        }
        self.currentUser = user
        getFeedingsForDay(NSDate())
    }
    
    func getFeedingsForDay(startingPoint: NSDate) {
        let calendar = NSCalendar.currentCalendar()
        let thisMorning = calendar.startOfDayForDate(startingPoint)
        let tonight = calendar.dateByAddingUnit(.Day, value: 1, toDate: thisMorning, options: [])!
        let query = PFQuery(className: "Feeding")
        query.whereKey("date", greaterThanOrEqualTo: thisMorning)
        query.whereKey("date", lessThan: tonight)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let feedings = objects?.map({FeedingViewModel(feeding: $0)}) {
                self.day = Day(feedings: feedings)
                self.day.calories.bindTo(self.caloriesLabel.bnd_text)
                self.day.volume.bindTo(self.volumeLabel.bnd_text)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func unwindFromAddingFeeding(sender: UIStoryboardSegue) {
        let vc = sender.sourceViewController as! AddFeedingViewController
        let feeding = vc.feeding!
        feeding.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            self.getFeedingsForDay(NSDate())
        }
    }
    
    @IBAction func unwindFromSignup(sender: UIStoryboardSegue) {
        
    }
}

extension FeedingsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.day.feedings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedingcell") as! FeedingsCell
        let feeding = day.feedings[indexPath.row]
        cell.timeLabel.text = feeding.time
        cell.mainLabel.text = feeding.summary
        cell.notesLabel.text = feeding.notes
        
        cell.mainLabel.setTextColor(UIColor(hex: 0x929292FF), string: "Cal /")
        cell.mainLabel.setTextColor(UIColor(hex: 0x929292FF), string: "mL")
        
        return cell
    }
}
