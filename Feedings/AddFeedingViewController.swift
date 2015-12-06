//
//  AddFeedingViewController.swift
//  Feedings
//
//  Created by Kevin McGladdery on 11/29/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit

class AddFeedingViewController: UIViewController {

    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var mlField: UITextField!
    @IBOutlet weak var caloriesField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var addFeedingButton: HighlightedButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let underlineColor = UIColor.init(hex: 0xD5D5D5FF)
        notesField.layer.borderColor = underlineColor.CGColor
        notesField.layer.borderWidth = 1.0
        notesField.layer.cornerRadius = 3.0

        addFeedingButton.backgroundColor = UIColor.darkGrayColor()
        
        addPickerTo(timeField, mode: .Time, format: "h:mm a")
        addPickerTo(dateField, mode: .Date, format: "dd-MM-yyyy")
    }
    
    func addPickerTo(field:UITextField, mode:UIDatePickerMode, format:String) {
        let picker = UIDatePicker()
        picker.datePickerMode = mode
        picker.backgroundColor = UIColor.whiteColor()
        picker.tintColor = UIColor.feedingsOrange
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        
        let toolbar = UIToolbar()
        toolbar.translucent = true
        toolbar.backgroundColor = UIColor.whiteColor()
        toolbar.tintColor = UIColor.feedingsOrange
        toolbar.sizeToFit()
        let barItems = [UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "tappedDone")]
        toolbar.setItems(barItems, animated: true)
        
        field.inputView = picker
        field.inputAccessoryView = toolbar
        picker.bnd_date.observe { date in
            field.text = formatter.stringFromDate(date)
        }
    }
    
    func tappedDone() {
        view.endEditing(true)
    }
    
    @IBAction func tappedBackground(sender: AnyObject) {
        view.endEditing(true)
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
