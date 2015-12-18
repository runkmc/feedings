//
//  FeedingViewModel.swift
//  Feedings
//
//  Created by Kevin McGladdery on 12/11/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import Parse

class FeedingViewModel {
    
    let calories: Int
    let volume: Int
    let date: NSDate
    let time: String
    let notes: String
    let baseFeeding: PFObject
    var summary: String {
        return "\(self.calories)Cal / \(self.volume)mL"
    }
    
    init(feeding:PFObject) {
        self.baseFeeding = feeding
        self.calories = feeding["calories"] as! Int
        self.volume = feeding["volume"] as! Int
        self.date = feeding["date"] as! NSDate
        let formatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a"
        self.time = formatter.stringFromDate(self.date)
        self.notes = feeding["notes"] as! String
    }
}
