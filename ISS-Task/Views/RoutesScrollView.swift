//
//  RoutesScrollView.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 26.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import UIKit

final class RoutesScrollView: UIScrollView {
  private var routeViews: [RouteView] = [] {
    didSet {
      stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
      routeViews.forEach { stackView.addArrangedSubview($0) }
    }
  }

  private let contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: routeViews)
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  // MARK: - Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  // MARK: - Methods
  func updateRoutes(routes: [Route]) {
    routeViews = routes.map { RouteView(route: $0) }
  }

  // MARK: - Private Methods
  private func setupView() {
    showsHorizontalScrollIndicator = false
    showsVerticalScrollIndicator = false

    addSubview(contentView)
    contentView.addSubview(stackView)

    let constraints = [
      contentLayoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      contentLayoutGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      contentLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
      contentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      frameLayoutGuide.heightAnchor.constraint(equalTo: contentLayoutGuide.heightAnchor),

      contentView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
      contentView.topAnchor.constraint(equalTo: stackView.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
    ]
    NSLayoutConstraint.activate(constraints)
  }
}
