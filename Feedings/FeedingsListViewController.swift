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
    var day = Day(date: Date(), feedings: [])
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
        refresh.addTarget(self, action: #selector(FeedingsListViewController.refreshPulled), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(FeedingsListViewController.getFeedingsOnLaunch),
            name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        guard let user = PFUser.currentUser() else {
            performSegue(withIdentifier: "showLoginController", sender: self)
            return
        }
        user.ACL = PFACL(user: user)
        self.currentUser = user
        pullRemoteChanges()
    }
    
    func getFeedingsOnLaunch() {
        pullRemoteChanges()
    }
    
    func getFeedingsForDay(_ startingPoint: Date) {
        let calendar = Calendar.current
        let thisMorning = calendar.startOfDay(for: startingPoint)
        let tonight = (calendar as NSCalendar).date(byAdding: .day, value: 1, to: thisMorning, options: [])!
        let query = PFQuery(className: "Feeding")
        query.fromLocalDatastore()
        query.whereKey("deleted", notEqualTo: true)
        query.whereKey("date", greaterThanOrEqualTo: thisMorning)
        query.whereKey("date", lessThan: tonight)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let feedings = objects?.map({FeedingViewModel(feeding: $0)}) {
                print("\(objects?.count)")
                self.day = Day(date: thisMorning, feedings: feedings)
                self.caloriesLabel.text = self.day.calories
                self.volumeLabel.text = self.day.volume
                self.dateLabel.text = self.day.date
                self.tableView.reloadData()
            }
        }
    }
    
    func pullRemoteChanges() {
        let defaults = UserDefaults.standard
        let rightNow = Date()
        let lastUpdated = defaults.object(forKey: "lastUpdated") as? Date ?? Date.distantPast
        let query = PFQuery(className: "Feeding")
        query.whereKey("updatedAt", greaterThanOrEqualTo: lastUpdated)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            PFObject.pinAllInBackground(objects) {
                (success:Bool, error:NSError?) -> () in
                print("\(objects?.count)")
                self.getFeedingsForDay(self.day.dateObject)
                self.refresh.endRefreshing()
                self.tableView.reloadData()
            }
        }
        defaults.set(rightNow, forKey: "lastUpdated")
    }
    
    func refreshPulled() {
        refresh.beginRefreshing()
        pullRemoteChanges()
    }
    
    @IBAction func previousDayTapped(_ sender: AnyObject) {
        let shownDate = day.dateObject
        let previousDay = (Calendar.current as NSCalendar).date(byAdding: .day, value: -1, to: shownDate, options: [])!
        getFeedingsForDay(previousDay)
    }
    
    @IBAction func nextDayTapped(_ sender: AnyObject) {
        let shownDate = day.dateObject
        let previousDay = (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: shownDate, options: [])!
        getFeedingsForDay(previousDay)
    }
    
    @IBAction func unwindFromAddingFeeding(_ sender: UIStoryboardSegue) {
        let vc = sender.source as! AddFeedingViewController
        let feeding = vc.feeding!
        feeding.saveEventually()
        feeding.pinInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            self.getFeedingsForDay(Date())
        }
    }
    
    @IBAction func unwindFromEditingFeeding(_ sender: UIStoryboardSegue) {
        let vc = sender.source as! EditFeedingViewController
        let feeding = vc.baseFeeding!
        feeding.saveEventually()
        feeding.pinInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            self.getFeedingsForDay(Date())
        }
    }
    
    @IBAction func unwindFromSignup(_ sender: UIStoryboardSegue) {
        self.getFeedingsForDay(day.dateObject)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditViewController" {
            guard let cell = sender as? FeedingsCell! else {
                return
            }
            let vc = segue.destination as! EditFeedingViewController
            vc.feeding = cell.feeding
        } else if segue.identifier == "showAddViewController" {
            let vc = segue.destination as! AddFeedingViewController
            vc.date = day.dateObject
        }
    }
}

extension FeedingsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.day.feedings.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let feeding = day.feedings[indexPath.row].baseFeeding
            feeding["deleted"] = true
            feeding.saveEventually()
            feeding.unpinInBackground()
            day.feedings.remove(at: indexPath.row)
            tableView.reloadData()
            caloriesLabel.text = day.calories
            volumeLabel.text = day.volume
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedingcell") as! FeedingsCell
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
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = NSLocalizedString("No Feedings for Today", comment: "")
        let attribs = [NSFontAttributeName: UIFont(name: "FiraSans-Medium", size: 18)!,
            NSForegroundColorAttributeName: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = NSLocalizedString("Add a feeding using the \"Add Feeding\" button below", comment: "")
        let lightGrey = UIColor.darkGray.lighten(0.2)!
        let attribs = [NSFontAttributeName: UIFont(name: "FiraSans-Book", size: 14)!,
            NSForegroundColorAttributeName: lightGrey]
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -70.0
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
