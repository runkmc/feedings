//
//  HighlightedButton.swift
//  
//
//  Created by Kevin McGladdery on 11/25/15.
//
//

import UIKit
import Colortools

class HighlightedButton: UIButton {
  @IBInspectable var buttonColor: UIColor?
    
    func animateBackgroundColorChange(color: UIColor?) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.1)
        self.backgroundColor = color
        UIView.commitAnimations()
    }
    
    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            if newValue {
                self.animateBackgroundColorChange(buttonColor?.tint(0.15))
            } else {
                self.backgroundColor = buttonColor
            }
            super.highlighted = newValue
            }
        }
}
