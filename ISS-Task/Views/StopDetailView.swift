//
//  StopDetailView.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 25.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import UIKit

final class StopDetailView: UIView {
  private let imageHeight = 30.0

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
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
  func configureWithStop(_ stop: Stop) {
    imageView.image = stop.transportTypes.first?.image ?? UIImage(systemName: "questionmark")
    nameLabel.text = stop.name
  }

  // MARK: - Private Methods
  private func setupView() {
    addSubview(imageView)
    addSubview(nameLabel)

    let constraints = [
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
      imageView.heightAnchor.constraint(equalToConstant: imageHeight),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

      nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: imageView.trailingAnchor, multiplier: 1),
      nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      nameLabel.topAnchor.constraint(equalTo: topAnchor),
      nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
    ]
    NSLayoutConstraint.activate(constraints)
  }
}
