//
//  AddFeedingViewController.swift
//  Feedings
//
//  Created by Kevin McGladdery on 11/29/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit
import Bond

class AddFeedingViewController: UIViewController {

    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var dateField: UITextFieldWithDate!
    @IBOutlet weak var mlField: UITextField!
    @IBOutlet weak var caloriesField: UITextField!
    @IBOutlet weak var timeField: UITextFieldWithDate!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var addFeedingButton: HighlightedButton!
    var feeding: PFObject?
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caloriesLabel.text = NSLocalizedString("calories", comment: "")
        volumeLabel.text = NSLocalizedString("mililiters", comment: "")
        dateLabel.text = NSLocalizedString("date", comment: "")
        timeLabel.text = NSLocalizedString("time", comment: "")
        notesLabel.text = NSLocalizedString("notes", comment: "")
        addFeedingButton.setTitle(NSLocalizedString("Add Feeding", comment: ""), for: UIControlState())
        let underlineColor = UIColor.init(hex: 0xD5D5D5FF)
        notesField.layer.borderColor = underlineColor.CGColor
        notesField.layer.borderWidth = 1.0
        notesField.layer.cornerRadius = 3.0

        addFeedingButton.backgroundColor = UIColor.darkGray
        
        addPickerTo(timeField, mode: .time, format: "h:mm a", withDate: Date())
        let dateToUse = self.date ?? Date()
        addPickerTo(dateField, mode: .date, format: "MM-dd-yyyy", withDate: dateToUse)
        addToolbarTo(caloriesField)
        addToolbarTo(mlField)
        addToolbarTo(caloriesField)
        addToolbarTo(mlField)
        addToolbarToView(notesField)
        
        addFeedingButton.bnd_enabled.observe { enabled in
            if enabled {
                self.addFeedingButton.backgroundColor = UIColor.feedingsOrange
            } else {
                self.addFeedingButton.backgroundColor = UIColor.darkGrayColor()
            }
        }
        
        combineLatest(caloriesField.bnd_text, mlField.bnd_text).map { cal, ml in
            return cal?.characters.count > 0 && ml?.characters.count > 0
        }.bindTo(addFeedingButton.bnd_enabled)
    }
    
    func addPickerTo(_ field:UITextFieldWithDate, mode:UIDatePickerMode, format:String, withDate:Date) {
        let picker = UIDatePicker()
        picker.datePickerMode = mode
        picker.backgroundColor = UIColor.white
        picker.tintColor = UIColor.feedingsOrange
        let formatter = DateFormatter()
        formatter.dateFormat = format
        picker.date = withDate
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
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddFeedingViewController.tappedDone))]
        toolbar.setItems(barItems, animated: true)
        return toolbar
    }
    
    func tappedDone() {
        view.endEditing(true)
    }
    
    @IBAction func tappedBackground(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func tappedAdd(_ sender: AnyObject) {
        let date = putTogetherDate(dateField.date! as Date, timeDate: timeField.date! as Date)
        let feeding = PFObject(className: "Feeding")
        feeding["date"] = date
        feeding["calories"] = Int(caloriesField.text!)
        feeding["volume"] = Int(mlField.text!)
        feeding["notes"] = notesField.text
        self.feeding = feeding
        performSegue(withIdentifier: "unwindFromAddingFeeding", sender: self)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
