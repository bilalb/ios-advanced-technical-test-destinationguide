//
//  SceneDelegate.swift
//  DestinationGuide
//
//  Created by Alexandre Guibert1 on 02/08/2021.
//

import Combine
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var coordinator: ApplicationCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
            coordinator = .init(
                window: window ?? .init(),
                rootViewController: .init(),
                recentDestinationsService: .init(),
                destinationStore: .shared,
                destinationFetchingService: .init()
            )
            coordinator?.start()
        }
    }
}
