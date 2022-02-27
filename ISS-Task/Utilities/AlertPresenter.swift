//
//  AlertPresenter.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 27.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import UIKit

enum AlertPresenter {
  static func showErrorAlert(message: String, on viewController: UIViewController?) {
    DispatchQueue.main.async {
      let title = NSLocalizedString("An error has occurred", comment: "AlertPresenter: Alert Title")
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alertController.view.tintColor = UIColor.accent

      let okAction = UIAlertAction(title: "OK", style: .default)
      alertController.addAction(okAction)

      weak var weakViewController = viewController
      weakViewController?.present(alertController, animated: true)
    }
  }
}
