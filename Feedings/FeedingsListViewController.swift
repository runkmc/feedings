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

class FeedingsListViewController: UIViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    @IBOutlet weak var tableView: UITableView!
    var currentUser: PFUser?
    var day = Day(date: NSDate(), feedings: [])
    let refresh = UIRefreshControl()
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var caloriesTitle: UILabel!
    @IBOutlet weak var volumeTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "FiraSans-Medium", size: 20)!, NSForegroundColorAttributeName: UIColor.feedingsOrange]
        caloriesTitle.text = NSLocalizedString("calories", comment: "")
        volumeTitle.text = NSLocalizedString("mililiters", comment: "")
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: "refreshPulled", forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getFeedingsOnLaunch",
            name: UIApplicationDidBecomeActiveNotification, object: UIApplication.sharedApplication())
        tableView.delegate = self
        tableView.dataSource = self
        guard let user = PFUser.currentUser() else {
            performSegueWithIdentifier("showLoginController", sender: self)
            return
        }
        user.ACL = PFACL(user: user)
        self.currentUser = user
        
        getFeedingsForDay(day.dateObject)
    }
    
    func getFeedingsOnLaunch() {
        getFeedingsForDay(day.dateObject)
    }
    
    func getFeedingsForDay(startingPoint: NSDate) {
        let calendar = NSCalendar.currentCalendar()
        let thisMorning = calendar.startOfDayForDate(startingPoint)
        let tonight = calendar.dateByAddingUnit(.Day, value: 1, toDate: thisMorning, options: [])!
        let query = PFQuery(className: "Feeding")
        query.fromLocalDatastore()
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
                self.pullRemoteChanges()
            }
        }
    }
    
    func pullRemoteChanges() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let rightNow = NSDate()
        let lastUpdated = defaults.objectForKey("lastUpdated") as? NSDate ?? NSDate.distantPast()
        let query = PFQuery(className: "Feeding")
        query.whereKey("updatedAt", greaterThanOrEqualTo: lastUpdated)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            PFObject.pinAllInBackground(objects)
        }
        defaults.setObject(rightNow, forKey: "lastUpdated")
        self.refresh.endRefreshing()
        tableView.reloadData()
    }
    
    func refreshPulled() {
        refresh.beginRefreshing()
        getFeedingsForDay(day.dateObject)
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
        feeding.saveEventually()
        feeding.pinInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            self.getFeedingsForDay(NSDate())
        }
    }
    
    @IBAction func unwindFromEditingFeeding(sender: UIStoryboardSegue) {
        let vc = sender.sourceViewController as! EditFeedingViewController
        let feeding = vc.baseFeeding!
        feeding.saveEventually()
        feeding.pinInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            self.getFeedingsForDay(NSDate())
        }
    }
    
    @IBAction func unwindFromSignup(sender: UIStoryboardSegue) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEditViewController" {
            guard let cell = sender as? FeedingsCell! else {
                return
            }
            let vc = segue.destinationViewController as! EditFeedingViewController
            vc.feeding = cell.feeding
        }
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
        cell.feeding = feeding
        
        cell.mainLabel.setTextColor(UIColor(hex: 0x929292FF), string: "Cal /")
        cell.mainLabel.setTextColor(UIColor(hex: 0x929292FF), string: "mL")
        
        return cell
    }
}

extension FeedingsListViewController {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = NSLocalizedString("No Feedings for Today", comment: "")
        let attribs = [NSFontAttributeName: UIFont(name: "FiraSans-Medium", size: 18)!,
            NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = NSLocalizedString("Add a feeding using the \"Add Feeding\" button below", comment: "")
        let lightGrey = UIColor.darkGrayColor().lighten(0.2)!
        let attribs = [NSFontAttributeName: UIFont(name: "FiraSans-Book", size: 14)!,
            NSForegroundColorAttributeName: lightGrey]
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -70.0
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
}