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
    let feeding: FeedingViewModel? = nil
    
    override func viewWillAppear(animated: Bool) {
        caloriesField.text = String(feeding!.calories)
        mlField.text = String(feeding!.volume)
        addPickerTo(timeField, mode: .Time, format: "h:mm a")
        addPickerTo(dateField, mode: .Date, format: "MM-dd-yyyy")
        addToolbarTo(caloriesField)
        addToolbarTo(mlField)
        
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
        saveFeeding.setTitle(NSLocalizedString("Save Feeding", comment: ""), forState: .Normal)
        let underlineColor = UIColor.init(hex: 0xD5D5D5FF)
        notesField.layer.borderColor = underlineColor.CGColor
        notesField.layer.borderWidth = 1.0
        notesField.layer.cornerRadius = 3.0
        
        saveFeeding.backgroundColor = UIColor.darkGrayColor()
        
    }
    
    func addPickerTo(field:UITextFieldWithDate, mode:UIDatePickerMode, format:String) {
        let picker = UIDatePicker()
        picker.datePickerMode = mode
        picker.backgroundColor = UIColor.whiteColor()
        picker.tintColor = UIColor.feedingsOrange
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        picker.date = feeding!.date
        field.inputView = picker
        addToolbarTo(field)
        
        picker.bnd_date.observe { date in
            field.text = formatter.stringFromDate(date)
            field.date = date
        }
    }
    
    func addToolbarTo(field:UITextField) {
        let toolbar = UIToolbar()
        toolbar.translucent = true
        toolbar.backgroundColor = UIColor.whiteColor()
        toolbar.tintColor = UIColor.feedingsOrange
        toolbar.sizeToFit()
        let barItems = [UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "tappedDone")]
        toolbar.setItems(barItems, animated: true)
        field.inputAccessoryView = toolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
