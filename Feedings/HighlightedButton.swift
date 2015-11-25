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
  
  override var highlighted: Bool {
    get {
      return super.highlighted
    }
    set {
      if newValue {
        self.backgroundColor = buttonColor?.tint(0.15)
      } else {
        self.backgroundColor = buttonColor
      }
      super.highlighted = newValue
    }
  }
}
