//
//  RouteView.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 26.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import UIKit

final class RouteView: UIView {
  private let numberButton: UIButton = {
    let button = UIButton(configuration: .filled())
    button.isUserInteractionEnabled = false
    let descriptor = UIFontDescriptor
      .preferredFontDescriptor(withTextStyle: .subheadline)
      .withSymbolicTraits(.traitBold)!
    button.titleLabel?.font = UIFont(descriptor: descriptor, size: 0)
    button.titleLabel?.adjustsFontForContentSizeCategory = true
    button.titleLabel?.textAlignment = .center
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
    button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
    return button
  }()

  private let arrivalLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .caption1)
    label.adjustsFontForContentSizeCategory = true
    label.textColor = UIColor.secondaryLabel
    label.textAlignment = .center
    return label
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [numberButton, arrivalLabel])
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  // MARK: - Initializers
  convenience init(route: Route) {
    self.init()
    setupView()
    configureWithRoute(route)
  }

  // MARK: - Private Methods
  private func setupView() {
    addSubview(stackView)

    let constraints = [
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ]
    NSLayoutConstraint.activate(constraints)
  }

  private func configureWithRoute(_ route: Route) {
    numberButton.configuration?.title = route.number
    numberButton.configuration?.baseForegroundColor = route.fontColor
    numberButton.configuration?.baseBackgroundColor = route.color

    arrivalLabel.text = route.timeArrival
  }
}
