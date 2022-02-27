//
//  RoutesParser.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 27.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import UIKit

struct RoutesParser {
  private enum JSONKeys {
    static let routePath = "routePath"
    static let number = "number"
    static let timeArrival = "timeArrival"
    static let color = "color"
    static let fontColor = "fontColor"
  }

  // MARK: - Methods
  func parseRoutes(from data: Data) throws -> [Route] {
    guard
      let jsonDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
      let jsonRoutes = jsonDictionary[JSONKeys.routePath] as? [[String: AnyObject]]
    else { throw URLError(.cannotDecodeRawData) }

    return try jsonRoutes.map(self.parseRoute(_:))
  }

  // MARK: - Private Methods
  private func parseRoute(_ route: [String: AnyObject]) throws -> Route {
    guard
      let number = route[JSONKeys.number] as? String,
      let timeArrival = route[JSONKeys.timeArrival] as? [String],
      let firstTimeArrival = timeArrival.first,
      let colorString = route[JSONKeys.color] as? String,
      let colorHex = hexStringToInt(colorString),
      let color = UIColor(hex: colorHex),
      let fontColorString = route[JSONKeys.fontColor] as? String,
      let fontColorHex = hexStringToInt(fontColorString),
      let fontColor = UIColor(hex: fontColorHex)
    else { throw URLError(.cannotDecodeRawData) }

    return Route(number: number, timeArrival: firstTimeArrival, color: color, fontColor: fontColor)
  }

  private func hexStringToInt(_ hexString: String) -> Int? {
    let stringWithoutHash = hexString.filter { $0 != "#" }
    return Int(stringWithoutHash, radix: 16)
  }
}
