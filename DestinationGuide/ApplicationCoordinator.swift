//
//  ApplicationCoordinator.swift
//  DestinationGuide
//
//  Created by Bilal on 16/08/2022.
//

import UIKit

final class ApplicationCoordinator: Coordinator {
    private let window: UIWindow
    private let rootViewController: UINavigationController

    init(window: UIWindow,
         rootViewController: UINavigationController) {
        self.window = window
        self.rootViewController = rootViewController
    }

    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
