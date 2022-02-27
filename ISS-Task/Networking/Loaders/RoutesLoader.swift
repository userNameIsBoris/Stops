//
//  RoutesLoader.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 26.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import Foundation

final class RoutesLoader {
  private let parser = RoutesParser()

  // MARK: - Methods
  func loadRoutes(ofStop stop: Stop, completion: @escaping (Result<[Route], Error>) -> Void) {
    let endpoint = Endpoints.routes(ofStop: stop)
    let dataTask = URLSession.shared.dataTask(with: endpoint) { [weak self] data, response, error in
      guard let self = self else { return }

      do {
        if let error = error {
          throw error
        }

        guard
          let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200
        else { throw URLError(.badServerResponse) }

        guard let data = data else { throw URLError(.cannotDecodeRawData) }

        let routes = try self.parser.parseRoutes(from: data)

        DispatchQueue.main.async {
          completion(.success(routes))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
    dataTask.resume()
  }
}
