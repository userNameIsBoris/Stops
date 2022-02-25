//
//  SceneDelegate.swift
//  ISS-Task
//
//  Created by Boris Ezhov on 25.02.2022.
//  Copyright (c) 2022 Boris Ezhov. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    setupWindow(scene: scene)
  }

  // MARK: - Private Methods
  private func setupWindow(scene: UIScene) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let controller = StopsViewController()

    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = tabController
    window?.rootViewController = controller
    window?.makeKeyAndVisible()
  }
}
