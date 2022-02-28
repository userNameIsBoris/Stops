//
//  StopPresenter.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 27.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import Foundation

protocol StopViewPresenter: AnyObject {
  func loadRoutes() async
}

final class StopPresenter: StopViewPresenter {
  var stop: Stop

  private unowned let view: StopView
  private let loader = RoutesLoader()

  // MARK: - Initializers
  init(view: StopView, stop: Stop) {
    self.view = view
    self.stop = stop
    view.configureWithStop(stop)
    UserDefaults.standard.set(customObject: stop, forKey: "selectedStop")
  }

  deinit {
    UserDefaults.standard.removeObject(forKey: "selectedStop")
  }

  // MARK: - Methods
  func loadRoutes() async {
    let result = await loader.loadRoutes(ofStop: stop)

    DispatchQueue.main.async {
      switch result {
      case .success(let routes):
        self.stop.routes = routes
        self.view.configureWithStop(self.stop)
      case .failure(let error):
        self.view.onLoadFailure(error: error)
      }
    }
  }
}
