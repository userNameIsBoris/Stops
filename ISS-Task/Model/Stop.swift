//
//  Stop.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 25.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import CoreLocation

struct Stop {
  var id: String
  var name: String
  var transportTypes: [TransportType]
  var coordinate: CLLocationCoordinate2D
  var routes: [Route]?

  var joinedTransportString: String {
    return transportTypes
      .map { $0.localizedString }
      .joined(separator: " • ")
  }

  // MARK: - Initializers
  init(
    id: String,
    name: String,
    transportTypes: [TransportType],
    latitude: CLLocationDegrees,
    longitude: CLLocationDegrees
  ) {
    self.id = id
    self.name = name
    self.transportTypes = transportTypes
    self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}
