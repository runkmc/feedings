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
        caloriesField.underline(underlineColor)
        dateField.underline(underlineColor)
        timeField.underline(underlineColor)
        mlField.underline(underlineColor)
        
        notesField.layer.borderColor = underlineColor.CGColor
        notesField.layer.borderWidth = 1.0
        notesField.layer.cornerRadius = 3.0

        addFeedingButton.backgroundColor = UIColor.darkGrayColor()
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .Date
        dateField.inputView = datePicker
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.addTarget(self, action: "updateDate:", forControlEvents: .ValueChanged)
        // Do any additional setup after loading the view.
    }
    
    func updateDate(sender:UIDatePicker) {
        
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
