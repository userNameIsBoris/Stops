//
//  StopViewController.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 25.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import UIKit
import MapKit

protocol StopView: AnyObject {
  func configureWithStop(_ stop: Stop)
  func onLoadFailure(error: Error)
}

final class StopViewController: UIViewController {
  private enum ReuseID {
    static let stopPin = "StopPin"
  }

  var presenter: StopPresenter!

  private lazy var mapView: MKMapView = {
    let mapView = MKMapView()
    mapView.delegate = self
    mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: ReuseID.stopPin)
    mapView.translatesAutoresizingMaskIntoConstraints = false
    return mapView
  }()

  private lazy var bottomStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [detailView, routesScrollView])
    stackView.axis = .vertical
    stackView.spacing = 32
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let detailView = StopDetailView()
  private let routesScrollView = RoutesScrollView()
  private let activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.tintColor = UIColor.accent
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    return activityIndicator
  }()

  private let spanMeters = 300.0

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = presenter.stop.transportTypes.first?.localizedString
    setupView()
    setupNavigation()
    loadRoutes()
  }

  // MARK: - Private Methods
  private func setupView() {
    view.backgroundColor = UIColor.secondarySystemBackground

    view.addSubview(mapView)

    let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.translatesAutoresizingMaskIntoConstraints = false
    bottomStackView.insertSubview(blurView, at: 0)

    view.addSubview(bottomStackView)
    view.addSubview(activityIndicator)

    let constraints = [
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      bottomStackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.5),

      blurView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor),
      blurView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor),
      blurView.topAnchor.constraint(equalTo: bottomStackView.topAnchor),
      blurView.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor),

      activityIndicator.centerXAnchor.constraint(equalTo: routesScrollView.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: routesScrollView.centerYAnchor),
    ]
    NSLayoutConstraint.activate(constraints)
  }

  private func setupNavigation() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.clear
    appearance.shadowColor = nil
    appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)

    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance

    let doneButton = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(dismissViewController))
    navigationItem.rightBarButtonItem = doneButton
  }

  @objc private func dismissViewController() {
    dismiss(animated: true)
  }

  private func loadRoutes() {
    activityIndicator.startAnimating()
    Task { await presenter.loadRoutes() }
  }
}

extension StopViewController: StopView {
  // MARK: - StopView
  func configureWithStop(_ stop: Stop) {
    activityIndicator.stopAnimating()

    mapView.region = MKCoordinateRegion(
      center: stop.coordinate,
      latitudinalMeters: spanMeters,
      longitudinalMeters: spanMeters)

    let annotation = MKPointAnnotation()
    annotation.coordinate = stop.coordinate
    annotation.title = stop.name
    annotation.subtitle = stop.joinedTransportString
    mapView.addAnnotation(annotation)

    detailView.configureWithStop(stop)
    routesScrollView.updateRoutes(routes: stop.routes ?? [])
  }

  func onLoadFailure(error: Error) {
    activityIndicator.stopAnimating()
    AlertPresenter.showErrorAlert(message: error.localizedDescription, on: self)
  }
}

extension StopViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: ReuseID.stopPin) as? MKMarkerAnnotationView
    pinView?.markerTintColor = UIColor.accent
    return pinView
  }
}
