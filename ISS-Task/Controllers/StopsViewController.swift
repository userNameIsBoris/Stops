//
//  StopsViewController.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 25.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import UIKit

protocol StopsView: AnyObject {
  func onLoadSuccess()
  func onLoadFailure(_ error: Error)
}

final class StopsViewController: UITableViewController {
  private enum ReuseID {
    static let stopCell = "StopCell"
  }

  var presenter: StopsViewPresenter!

  private lazy var searchController: UISearchController = {
    let controller = UISearchController()
    controller.searchBar.placeholder = NSLocalizedString(
      "Stop name, transport type...",
      comment: "StopsViewController: Search Bar Placeholder")
    controller.searchResultsUpdater = self
    return controller
  }()

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = NSLocalizedString("Stops", comment: "StopsViewController: Title")
    setupView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadStops()
  }

  // MARK: - Private Methods
  private func setupView() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReuseID.stopCell)
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.tintColor = UIColor.accent
    tableView.refreshControl?.addTarget(self, action: #selector(loadStops), for: .valueChanged)
    tableView.separatorInset = .zero
  }

  @objc private func loadStops() {
    tableView.refreshControl?.beginRefreshing()
    presenter.loadStops()
  }

  private func presentStopVC(selectedStop: Stop) {
    let controller = StopViewController()
    let presenter = StopPresenter(view: controller, stop: selectedStop)
    controller.presenter = presenter
    let navController = UINavigationController(rootViewController: controller)
    present(navController, animated: true)
  }
}

extension StopsViewController: StopsView {
  // MARK: - StopsView
  func onLoadSuccess() {
    tableView.refreshControl?.endRefreshing()
    tableView.reloadData()
  }

  func onLoadFailure(_ error: Error) {
    tableView.refreshControl?.endRefreshing()
    AlertPresenter.showErrorAlert(message: error.localizedDescription, on: self)
  }
}

extension StopsViewController {
  // MARK: - Table View Data Source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.filteredStops.isEmpty && presenter.areStopsLoaded ? 1 : presenter.filteredStops.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.stopCell, for: indexPath)

    if presenter.filteredStops.isEmpty {
      cell.accessoryType = .none
      configureCell(cell)
    } else {
      let stop = presenter.filteredStops[indexPath.row]
      cell.accessoryType = .disclosureIndicator
      configureCell(cell, withStop: stop)
    }

    return cell
  }

  private func configureCell(_ cell: UITableViewCell, withStop stop: Stop? = nil) {
    var contentConfiguration = cell.defaultContentConfiguration()
    defer { cell.contentConfiguration = contentConfiguration }

    guard let stop = stop else {
      contentConfiguration.text = NSLocalizedString(
        "There are no appropriate stops :(",
        comment: "StopsViewController: Empty Stops Cell Title")
      contentConfiguration.textProperties.color = UIColor.secondaryLabel
      return
    }

    contentConfiguration.text = stop.name
    contentConfiguration.secondaryText = stop.joinedTransportString
    contentConfiguration.secondaryTextProperties.color = UIColor.secondaryLabel
    contentConfiguration.image = stop.transportTypes.first?.image ?? UIImage(systemName: "questionmark")
  }

  // MARK: - Table View Delegate
  override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return !presenter.filteredStops.isEmpty
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let stop = presenter.filteredStops[indexPath.row]
    presentStopVC(selectedStop: stop)
  }
}

extension StopsViewController: UISearchResultsUpdating {
  // MARK: - Search Results Updating
  func updateSearchResults(for searchController: UISearchController) {
    defer { tableView.reloadData() }

    if let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty {
      presenter.filterStops(searchText: searchText)
    } else {
      presenter.resetFilter()
    }
  }
}
