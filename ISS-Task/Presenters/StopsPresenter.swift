//
//  StopsPresenter.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 27.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import Foundation

protocol StopsViewPresenter: AnyObject {
  var stopToPresent: Stop? { get }
  var filteredStops: [Stop] { get }
  var areStopsLoaded: Bool { get }

  func loadStops() async
  func filterStops(searchText: String)
  func resetFilter()
}

final class StopsPresenter: StopsViewPresenter {
  var stopToPresent: Stop?
  var filteredStops: [Stop] = []
  var areStopsLoaded = false

  private var stops: [Stop] = [] {
    didSet { filteredStops = stops }
  }

  private unowned let view: StopsView
  private let loader = StopsLoader()

  // MARK: - Initializers
  init(view: StopsView) {
    self.view = view
  }

  // MARK: - Methods
  func loadStops() async {
    let result = await loader.loadStops()

    DispatchQueue.main.async {
      switch result {
      case .success(let stops):
        self.stops = stops
        self.areStopsLoaded = true
        self.view.onLoadSuccess()
      case .failure(let error):
        self.view.onLoadFailure(error)
      }
    }
  }

  func filterStops(searchText: String) {
    filteredStops = stops.filter {
      return $0.name.lowercased().contains(searchText) || $0.joinedTransportString.lowercased().contains(searchText)
    }
  }

  func resetFilter() {
    filteredStops = stops
  }
}
