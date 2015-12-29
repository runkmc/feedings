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
    var day = Day(date: NSDate(), feedings: [])
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var caloriesTitle: UILabel!
    @IBOutlet weak var volumeTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "FiraSans-Medium", size: 20)!, NSForegroundColorAttributeName: UIColor.feedingsOrange]
        caloriesTitle.text = NSLocalizedString("calories", comment: "")
        volumeTitle.text = NSLocalizedString("mililiters", comment: "")
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
        getFeedingsForDay(day.dateObject)
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
                self.day = Day(date: thisMorning, feedings: feedings)
                self.caloriesLabel.text = self.day.calories
                self.volumeLabel.text = self.day.volume
                self.dateLabel.text = self.day.date
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func previousDayTapped(sender: AnyObject) {
        let shownDate = day.dateObject
        let previousDay = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: shownDate, options: [])!
        getFeedingsForDay(previousDay)
    }
    
    @IBAction func nextDayTapped(sender: AnyObject) {
        let shownDate = day.dateObject
        let previousDay = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: shownDate, options: [])!
        getFeedingsForDay(previousDay)
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let feeding = day.feedings[indexPath.row].baseFeeding
            feeding.deleteInBackground()
            day.feedings.removeAtIndex(indexPath.row)
            tableView.reloadData()
            caloriesLabel.text = day.calories
            volumeLabel.text = day.volume
        }
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
