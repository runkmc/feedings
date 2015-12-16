//
//  Day.swift
//  Feedings
//
//  Created by Kevin McGladdery on 12/11/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import Parse
import Bond

class Day {
    
    let calories: Observable<String> 
    let volume: Observable<String>
    var feedings: [FeedingViewModel]
    
    init(feedings: [FeedingViewModel]) {
        self.feedings = feedings
        self.volume = Observable("\(feedings.map({$0.volume}).reduce(0, combine: +))")
        self.calories = Observable("\(feedings.map({$0.calories}).reduce(0, combine: +))")
    }
    
}
