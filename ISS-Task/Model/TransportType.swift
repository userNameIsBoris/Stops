//
//  TransportType.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 25.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import Foundation

enum TransportType: String {
  case bus
  case mcd
  case subwayHall
  case train
  case tram

  var localizedString: String {
    switch self {
    case .bus: return NSLocalizedString("Bus stop", comment: "TransportType: Localized String")
    case .mcd: return NSLocalizedString("MCD station", comment: "TransportType: Localized String")
    case .subwayHall: return NSLocalizedString("Subway hall", comment: "TransportType: Localized String")
    case .train: return NSLocalizedString("Train station", comment: "TransportType: Localized String")
    case .tram: return NSLocalizedString("Tram stop", comment: "TransportType: Localized String")
    }
  }
}
