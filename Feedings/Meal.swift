//
//  Meal.swift
//  Feedings
//
//  Created by Kevin McGladdery on 10/31/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation

class Meal {
  
  var calories : Int
  var date : NSDate
  
  init(calories:Int, date:NSDate) {
    self.calories = calories
    self.date = date
  }
}