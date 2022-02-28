//
//  UserDefaults+CustomObject.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 27.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import Foundation

extension UserDefaults {
  func set<T: Codable>(customObject object: T, forKey key: String) {
    let encoder = JSONEncoder()
    guard let encodedObject = try? encoder.encode(object) else { return }
    set(encodedObject, forKey: key)
  }

  func customObject<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
    guard let data = data(forKey: key) else { return nil }
    let decoder = JSONDecoder()
    guard let decodedObject = try? decoder.decode(type, from: data) else { return nil }
    return decodedObject
  }
}
