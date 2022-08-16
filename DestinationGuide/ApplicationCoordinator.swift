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
    private let destinationListCoordinator: DestinationListViewController.Coordinator

    init(window: UIWindow,
         rootViewController: UINavigationController,
         recentDestinationsService: RecentDestinationsService,
         destinationStore: DestinationStore,
         destinationFetchingService: DestinationFetchingService) {
        self.window = window
        self.rootViewController = rootViewController

        destinationListCoordinator = .init(
            navigationController: rootViewController,
            recentDestinationsService: recentDestinationsService,
            destinationStore: destinationStore,
            destinationFetchingService: destinationFetchingService
        )
    }

    func start() {
        window.rootViewController = rootViewController
        destinationListCoordinator.start()
        window.makeKeyAndVisible()
    }
}
