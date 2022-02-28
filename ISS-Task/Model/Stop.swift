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

extension Stop: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case transportTypes
    case latitude
    case longitude
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try values.decode(String.self, forKey: .id)
    self.name = try values.decode(String.self, forKey: .name)
    self.transportTypes = try values.decode([TransportType].self, forKey: .transportTypes)

    let latitude = try values.decode(CLLocationDegrees.self, forKey: .latitude)
    let longitude = try values.decode(CLLocationDegrees.self, forKey: .longitude)
    self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(transportTypes, forKey: .transportTypes)
    try container.encode(coordinate.latitude, forKey: .latitude)
    try container.encode(coordinate.longitude, forKey: .longitude)
  }
}
