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
    
    let calories: String
    let volume: String
    var summary: String {
        return "\(self.calories)Cal / \(self.volume)ml"
    }
    
    init(feeding:PFObject) {
        self.calories = "\(feeding["calories"])"
        self.volume = "\(feeding["volume"])"
    }
}
