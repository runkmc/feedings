//
//  FeedingsTests.swift
//  FeedingsTests
//
//  Created by Kevin McGladdery on 10/28/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//


@testable import Feedings
import Quick
import Nimble

class MealSpec : QuickSpec {
  override func spec() {
    describe("It Exists") {
      let calories = 250
      let date = NSDate()
      let volume = 220
      let meal = Meal(calories:calories, date:date, volume:volume)
      
      it("has a calories property") {
        expect(meal.calories) == 250
      }
      
      it("has a date property") {
        expect(meal.date) == date
      }
      
      it("has a volume") {
        expect(meal.volume) == volume
      }
    }
  }
}