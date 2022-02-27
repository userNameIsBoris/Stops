//
//  StopsParser.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 27.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import Foundation

struct StopsParser {
  private enum JSONKeys {
    static let data = "data"
    static let id = "id"
    static let name = "name"
    static let transportTypes = "transportTypes"
    static let latitude = "lat"
    static let longitude = "lon"
  }

  // MARK: - Methods
  func parseStops(from data: Data) throws -> [Stop] {
    guard
      let jsonDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
      let jsonStops = jsonDictionary[JSONKeys.data] as? [[String: AnyObject]]
    else { throw URLError(.cannotDecodeRawData) }

    return try jsonStops.map(self.parseStop(_:))
  }

  // MARK: - Private Methods
  private func parseStop(_ stop: [String: AnyObject]) throws -> Stop {
    guard
      let id = stop[JSONKeys.id] as? String,
      let name = stop[JSONKeys.name] as? String,
      let transportTypesString = stop[JSONKeys.transportTypes] as? [String],
      let latitude = stop[JSONKeys.latitude] as? Double,
      let longitude = stop[JSONKeys.longitude] as? Double
    else { throw URLError(.cannotDecodeRawData) }

    let transportTypes = transportTypesString.compactMap { TransportType(rawValue: $0) }

    return Stop(id: id, name: name, transportTypes: transportTypes, latitude: latitude, longitude: longitude)
  }
}
