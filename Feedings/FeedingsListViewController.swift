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

class FeedingsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var currentUser: PFUser?
    var day = Day(feedings: [])
    
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
        let calendar = NSCalendar.currentCalendar()
        let thisMorning = calendar.startOfDayForDate(NSDate())
        getFeedingsForDay(thisMorning, calendar: calendar)
    }
    
    func getFeedingsForDay(startingPoint: NSDate, calendar: NSCalendar) {
        let tonight = calendar.dateByAddingUnit(.Day, value: 1, toDate: startingPoint, options: [])!
        let query = PFQuery(className: "Feeding")
        query.whereKey("date", greaterThanOrEqualTo: startingPoint)
        query.whereKey("date", lessThan: tonight)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let feedings = objects?.map({FeedingViewModel(feeding: $0)}) {
                self.day = Day(feedings: feedings)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func unwindFromAddingFeeding(sender: UIStoryboardSegue) {
        
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
        cell.mainLabel.setTextColor(UIColor(hex: 0x929292FF), string: "ml")
        
        return cell
    }
}
