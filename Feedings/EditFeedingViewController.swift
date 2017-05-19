//
//  EditFeedingViewController.swift
//  Feedings
//
//  Created by Kevin McGladdery on 12/30/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit
import Bond
import Parse

class EditFeedingViewController: UIViewController {

    @IBOutlet weak var saveFeeding: UIButton!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var timeField: UITextFieldWithDate!
    @IBOutlet weak var dateField: UITextFieldWithDate!
    @IBOutlet weak var caloriesField: UITextField!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var mlField: UITextField!
    var feeding: FeedingViewModel? = nil
    var baseFeeding: PFObject? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        caloriesField.text = String(feeding!.calories)
        mlField.text = String(feeding!.volume)
        notesField.text = feeding!.notes
        addPickerTo(timeField, mode: .time, format: "h:mm a")
        addPickerTo(dateField, mode: .date, format: "MM-dd-yyyy")
        addToolbarTo(caloriesField)
        addToolbarTo(mlField)
        addToolbarToView(notesField)
        
        saveFeeding.bnd_enabled.observe { enabled in
            if enabled {
                self.saveFeeding.backgroundColor = UIColor.feedingsOrange
            } else {
                self.saveFeeding.backgroundColor = UIColor.darkGrayColor()
            }
        }
        
        combineLatest(caloriesField.bnd_text, mlField.bnd_text).map { cal, ml in
            return cal?.characters.count > 0 && ml?.characters.count > 0
            }.bindTo(saveFeeding.bnd_enabled)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caloriesLabel.text = NSLocalizedString("calories", comment: "")
        volumeLabel.text = NSLocalizedString("mililiters", comment: "")
        dateLabel.text = NSLocalizedString("date", comment: "")
        timeLabel.text = NSLocalizedString("time", comment: "")
        notesLabel.text = NSLocalizedString("notes", comment: "")
        saveFeeding.setTitle(NSLocalizedString("Save Feeding", comment: ""), for: UIControlState())
        let underlineColor = UIColor.init(hex: 0xD5D5D5FF)
        notesField.layer.borderColor = underlineColor.CGColor
        notesField.layer.borderWidth = 1.0
        notesField.layer.cornerRadius = 3.0
        saveFeeding.backgroundColor = UIColor.darkGray
    }
    
    func addPickerTo(_ field:UITextFieldWithDate, mode:UIDatePickerMode, format:String) {
        let picker = UIDatePicker()
        picker.datePickerMode = mode
        picker.backgroundColor = UIColor.white
        picker.tintColor = UIColor.feedingsOrange
        let formatter = DateFormatter()
        formatter.dateFormat = format
        picker.date = feeding!.date as Date
        field.inputView = picker
        addToolbarTo(field)
        
        picker.bnd_date.observe { date in
            field.text = formatter.stringFromDate(date)
            field.date = date
        }
    }
    
    func addToolbarTo(_ field:UITextField) {
        let toolbar = createToolbar()
        field.inputAccessoryView = toolbar
    }
    
    func addToolbarToView(_ field:UITextView) {
        let toolbar = createToolbar()
        field.inputAccessoryView = toolbar
    }
    
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.isTranslucent = true
        toolbar.backgroundColor = UIColor.white
        toolbar.tintColor = UIColor.feedingsOrange
        toolbar.sizeToFit()
        let barItems = [UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(EditFeedingViewController.tappedDone))]
        toolbar.setItems(barItems, animated: true)
        return toolbar
    }

    func tappedDone() {
        view.endEditing(true)
    }
    
    @IBAction func tappedBackground(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveFeedingTapped(_ sender: AnyObject) {
        let date = putTogetherDate(dateField.date! as Date, timeDate: timeField.date! as Date)
        let updatedFeeding = feeding!.baseFeeding
        updatedFeeding["date"] = date
        updatedFeeding["calories"] = Int(caloriesField.text!)
        updatedFeeding["volume"] = Int(mlField.text!)
        updatedFeeding["notes"] = notesField.text
        self.baseFeeding = updatedFeeding
        performSegue(withIdentifier: "unwindFromEditingFeeding", sender: self)
    }
    
    func putTogetherDate(_ calendarDate: Date, timeDate: Date) -> Date {
        let calendar = Calendar.current
        let calendarComponents = (calendar as NSCalendar).components([.month, .day, .year], from: calendarDate)
        let timeComponents = (calendar as NSCalendar).components([.hour, .minute], from: timeDate)
        var components = DateComponents()
        components.year = calendarComponents.year
        components.month = calendarComponents.month
        components.day = calendarComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        
        return calendar.date(from: components)!
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
