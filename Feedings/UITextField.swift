//
//  UITextField.swift
//  Feedings
//
//  Created by Kevin McGladdery on 11/26/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit

extension UITextField {
    func underline(color: UIColor) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, self.frame.size.height - 1, self.frame.size.width, 1.0)
        bottomBorder.backgroundColor = color.CGColor
        self.layer.addSublayer(bottomBorder)
    }
}