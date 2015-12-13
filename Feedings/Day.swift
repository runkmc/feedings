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
    
    var calories: String {
        return "\(feedings.map({$0.calories}).reduce(0, combine: +))"
    }
    var feedings: [FeedingViewModel]
    
    init(feedings: [FeedingViewModel]) {
        self.feedings = feedings
    }
    
}
