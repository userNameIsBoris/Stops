//
//  StopsLoader.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 25.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import Foundation

final class StopsLoader {
  private let parser = StopsParser()

  // MARK: - Methods
  func loadStops(completion: @escaping (Result<[Stop], Error>) -> Void) {
    let dataTask = URLSession.shared.dataTask(with: Endpoints.stops) { [weak self] data, response, error in
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

        let stops = try self.parser.parseStops(from: data)

        DispatchQueue.main.async {
          completion(.success(stops))
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
