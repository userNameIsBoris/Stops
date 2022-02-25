//
//  StopsViewController.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 25.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import UIKit
import CoreLocation

// TODO: Add UISearchBar
// TODO: Add UIRefreshControl

final class StopsViewController: UITableViewController {
  private let reuseID = "StopCell"
  private let loader = StopsLoader()
  private var stops: [Stop] = []

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = NSLocalizedString("Stops", comment: "StopsViewController: Title")
    setupView()
    loadStops()
  }

  // MARK: - Private Methods
  private func setupView() {
    navigationController?.navigationBar.prefersLargeTitles = true
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
  }

  private func loadStops() {
    loader.loadStops { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .success(let stops):
        self.stops = stops
        self.tableView.reloadData()
      case .failure(let error):
        // TODO: Show alert
        print(error)
      }
    }
  }

  private func presentStopViewController(selectedStop: Stop) {
    let controller = StopViewController(stop: selectedStop)
    let navController = UINavigationController(rootViewController: controller)
    present(navController, animated: true)
  }
}

extension StopsViewController {
  // MARK: - UITableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stops.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let stop = stops[indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
    cell.accessoryType = .disclosureIndicator

    var contentConfiguration = cell.defaultContentConfiguration()
    contentConfiguration.text = stop.name
    contentConfiguration.secondaryText = stop.transportTypes
      .map { $0.localizedString }
      .joined(separator: " • ")
    contentConfiguration.secondaryTextProperties.color = UIColor.secondaryLabel
    cell.contentConfiguration = contentConfiguration

    return cell
  }

  // MARK: - UITableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let stop = stops[indexPath.row]
    presentStopViewController(selectedStop: stop)
  }
}
