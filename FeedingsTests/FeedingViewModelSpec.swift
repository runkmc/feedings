//
//  FeedingViewModelSpec.swift
//  Feedings
//
//  Created by Kevin McGladdery on 12/11/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Feedings

class FeedingViewModelSpec: QuickSpec {
    override func spec() {
        describe("View-ready attributes") {
            let calendar = NSCalendar.current
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
                expect(model.summary) == "200Cal / 240mL"
            }
            
            it("returns a time string") {
                expect(model.time) == "1:30 PM"
            }
            
            it("returns a feeding's notes") {
                expect(model.notes) == "I mixed in some crunchberries. This turned out to be a mistake."
            }
            
            it("is comparable") {
                let feeding2 = PFObject(className: "Feeding")
                feeding2["calories"] = 200
                feeding2["volume"] = 240
                feeding2["notes"] = "I mixed in some crunchberries. This turned out to be a mistake."
                feeding2["date"] = NSDate.distantPast()
                let pastFeeding = FeedingViewModel(feeding: feeding2)
                let feeding3 = PFObject(className: "Feeding")
                feeding3["calories"] = 200
                feeding3["volume"] = 240
                feeding3["notes"] = "I mixed in some crunchberries. This turned out to be a mistake."
                feeding3["date"] = NSDate.distantFuture()
                let futureFeeding = FeedingViewModel(feeding: feeding3)
                
                expect(model > pastFeeding) == true
                expect(model < futureFeeding) == true
                expect(model == model) == true
                expect(futureFeeding < pastFeeding) == false
                
            }
        }
    }
}

