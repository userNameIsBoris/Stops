//
//  RoutesLoader.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 26.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import Foundation

struct RoutesLoader {
  private let parser = RoutesParser()

  // MARK: - Methods
  func loadRoutes(ofStop stop: Stop) async -> Result<[Route], Error> {
    let endpoint = Endpoints.routes(ofStop: stop)

    do {
      let (data, response) = try await URLSession.shared.data(from: endpoint)

      guard
        let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode == 200
      else { throw URLError(.badServerResponse) }

      let routes = try parser.parseRoutes(from: data)
      return .success(routes)
    } catch {
      return .failure(error)
    }
  }
}
