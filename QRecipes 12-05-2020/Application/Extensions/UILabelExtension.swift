//
//  UILabelExtension.swift
//  QRecipes
//
//  Created by Kyo on 9/23/20.
//  Copyright © 2020 Kyo. All rights reserved.
//
import UIKit

extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: textString.count))
            self.attributedText = attributedString
        }
    }
}
