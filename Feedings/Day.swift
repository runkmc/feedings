//
//  Day.swift
//  Feedings
//
//  Created by Kevin McGladdery on 12/11/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import Parse

class Day {
    
    var calories: String
    var volume: String
    let date: String
    let dateObject: NSDate
    var feedings: [FeedingViewModel] {
        didSet {
            updateTotals()
        }
    }
    
    init(date: NSDate, feedings: [FeedingViewModel]) {
        self.feedings = feedings
        self.volume = "\(feedings.map({$0.volume}).reduce(0, combine: +))"
        self.calories = "\(feedings.map({$0.calories}).reduce(0, combine: +))"
        self.dateObject = date
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        self.date = formatter.stringFromDate(date)
    }
    
    func updateTotals() {
        self.volume = "\(feedings.map({$0.volume}).reduce(0, combine: +))"
        self.calories = "\(feedings.map({$0.calories}).reduce(0, combine: +))"
    }
    
}
