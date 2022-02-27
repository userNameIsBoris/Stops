//
//  StopPresenter.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 27.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import Foundation

protocol StopViewPresenter: AnyObject {
  func loadRoutes()
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
  }

  // MARK: - Methods
  func loadRoutes() {
    loader.loadRoutes(ofStop: stop) { [weak self] result in
      guard let self = self else { return }

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
