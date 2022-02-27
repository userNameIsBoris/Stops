//
//  Endpoints.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 26.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import Foundation

enum Endpoints {
  static let stops = URL(string: "https://api.mosgorpass.ru/v8.2/stop")!

  static func routes(ofStop stop: Stop) -> URL {
    return stops.appendingPathComponent(stop.id)
  }
}
