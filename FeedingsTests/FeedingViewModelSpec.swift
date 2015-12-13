//
//  FeedingViewModelSpec.swift
//  Feedings
//
//  Created by Kevin McGladdery on 12/11/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import Parse
import Quick
import Nimble
@testable import Feedings

class FeedingViewModelSpec: QuickSpec {
    override func spec() {
        describe("View-ready attributes") {
            let calendar = NSCalendar.currentCalendar()
            let feeding = PFObject(className: "Feeding")
            feeding["date"] = calendar.dateBySettingHour(13, minute: 30, second: 0, ofDate: NSDate(), options: [])
            feeding["calories"] = 200
            feeding["volume"] = 240
            feeding["notes"] = "I mixed in some crunchberries. This turned out to be a mistake."
            let model = FeedingViewModel(feeding: feeding)
            
            it("returns a string with calories") {
                expect(model.calories) == 200
            }
            
            it("returns a string with volume") {
                expect(model.volume) == 240
            }
            
            it("returns a summary string") {
                expect(model.summary) == "200Cal / 240ml"
            }
            
            it("returns a time string") {
                expect(model.time) == "1:30 PM"
            }
            
            it("returns a feeding's notes") {
                expect(model.notes) == "I mixed in some crunchberries. This turned out to be a mistake."
            }
        }
    }
}
