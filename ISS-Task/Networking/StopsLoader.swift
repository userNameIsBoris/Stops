//
//  StopsLoader.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 25.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import Foundation

final class StopsLoader {
  private let endpoint = URL(string: "https://api.mosgorpass.ru/v8.2/stop")!

  // MARK: - Methods
  func loadStops(completion: ((Result<[Stop], Error>) -> Void)?) {
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

        guard
          let jsonDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
          let jsonStops = jsonDictionary["data"] as? [[String: AnyObject]]
        else { throw URLError(.cannotDecodeRawData) }

        let stops = try jsonStops.map(self.parseStop(_:))

        DispatchQueue.main.async {
          completion?(.success(stops))
        }
      } catch {
        DispatchQueue.main.async {
          completion?(.failure(error))
        }
      }
    }
    dataTask.resume()
  }

  // MARK: - Private Methods
  private func parseStop(_ stop: [String: AnyObject]) throws -> Stop {
    guard
      let idString = stop["id"] as? String,
      let id = UUID(uuidString: idString),
      let name = stop["name"] as? String,
      let transportTypesString = stop["transportTypes"] as? [String],
      let latitude = stop["lat"] as? Double,
      let longitude = stop["lon"] as? Double
    else { throw URLError(.cannotDecodeRawData) }

    let transportTypes = transportTypesString.compactMap { TransportType(rawValue: $0) }

    return Stop(id: id, name: name, transportTypes: transportTypes, latitude: latitude, longitude: longitude)
  }
}
