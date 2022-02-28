//
//  StopsLoader.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 25.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import Foundation

struct StopsLoader {
  private let parser = StopsParser()

  // MARK: - Methods
  func loadStops() async -> Result<[Stop], Error> {
    do {
      let (data, response) = try await URLSession.shared.data(from: Endpoints.stops)

      guard
        let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode == 200
      else { throw URLError(.badServerResponse) }

      let stops = try parser.parseStops(from: data)
      return .success(stops)
    } catch {
      return .failure(error)
    }
  }
}
