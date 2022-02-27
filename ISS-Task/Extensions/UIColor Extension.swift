//
//  UIColor Extension.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 26.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init?(hex: Int) {
    let red = (hex >> 16) & 0xFF
    let green = (hex >> 8) & 0xFF
    let blue = hex & 0xFF

    let range = 0...255
    guard range.contains(red) && range.contains(green) && range.contains(blue) else { return nil }

    self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
  }
}

extension UIColor {
  static let accent = UIColor(named: "AccentColor")!
}
