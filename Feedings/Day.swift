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
    let dateObject: Date
    var feedings: [FeedingViewModel] {
        didSet {
            updateTotals()
        }
    }
    
    init(date: Date, feedings: [FeedingViewModel]) {
        self.feedings = feedings.sorted()
        self.volume = "\(feedings.map({$0.volume}).reduce(0, +))"
        self.calories = "\(feedings.map({$0.calories}).reduce(0, +))"
        self.dateObject = date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        self.date = formatter.string(from: date)
    }
    
    func updateTotals() {
        self.volume = "\(feedings.map({$0.volume}).reduce(0, +))"
        self.calories = "\(feedings.map({$0.calories}).reduce(0, +))"
    }
    
}
