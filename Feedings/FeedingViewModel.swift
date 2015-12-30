//
//  FeedingViewModel.swift
//  Feedings
//
//  Created by Kevin McGladdery on 12/11/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import Parse

class FeedingViewModel: Comparable {
    
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

func ==(x:FeedingViewModel, y:FeedingViewModel) -> Bool {
    return x.date.isEqualToDate(y.date)
}

func <(x:FeedingViewModel, y:FeedingViewModel) -> Bool {
    let earlier = x.date.earlierDate(y.date)
    if earlier == x.date {
        return true
    }
    return false
}