//
//  DaySpec.swift
//  Feedings
//
//  Created by Kevin McGladdery on 12/12/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Parse
@testable import Feedings

class DaySpec: QuickSpec {
    override func spec() {
        describe("The Day Viewmodel") {
            let day = self.setupDay()
            
            it("returns the day's calorie count") {
                expect(day.calories) == "645"
            }
            
            it("returns the day's volume amount") {
                expect(day.volume) == "770"
            }
            
            it("returns 0 calories when there are no feedings yet") {
                let emptyDay = Day(feedings: [])
                expect(emptyDay.calories) == "0"
            }
            
            it("returns 0 ml when there are no feedings yet") {
                let emptyDay = Day(feedings: [])
                expect(emptyDay.volume) == "0"
            }
            
            it("deletes a day when asked") {
                day.feedings.removeAtIndex(1)
                expect(day.calories) == "400"
                expect(day.volume) == "480"
            }
        }
    }
    
    func setupDay() -> Day {
        let calendar = NSCalendar.currentCalendar()
        let feeding1 = PFObject(className: "Feeding")
        feeding1["date"] = calendar.dateBySettingHour(9, minute: 30, second: 0, ofDate: NSDate(), options: [])
        feeding1["calories"] = 200
        feeding1["volume"] = 240
        feeding1["notes"] = "I mixed in some crunchberries. This turned out to be a mistake."
        let model1 = FeedingViewModel(feeding: feeding1)
        let feeding2 = PFObject(className: "Feeding")
        feeding2["date"] = calendar.dateBySettingHour(11, minute: 45, second: 0, ofDate: NSDate(), options: [])
        feeding2["calories"] = 245
        feeding2["volume"] = 290
        feeding2["notes"] = "I mixed in some bourbon. This turned out to be a mistake."
        let model2 = FeedingViewModel(feeding: feeding2)
        let feeding3 = PFObject(className: "Feeding")
        feeding3["date"] = calendar.dateBySettingHour(15, minute: 10, second: 0, ofDate: NSDate(), options: [])
        feeding3["calories"] = 200
        feeding3["volume"] = 240
        feeding3["notes"] = "I mixed in some chili powder. This turned out to be a mistake."
        let model3 = FeedingViewModel(feeding: feeding3)
        return Day(feedings: [model1, model2, model3])
    }
}