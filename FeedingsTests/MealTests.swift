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
      it("has a calories property") {
        let meal : Meal = Meal(calories:250)
        expect(meal.calories) == 250
      }
    }
  }
}