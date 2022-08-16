//
//  DestinationListViewController.Coordinator.swift
//  DestinationGuide
//
//  Created by Bilal on 16/08/2022.
//

import Combine
import UIKit

extension DestinationListViewController {
    final class Coordinator: DestinationGuide.Coordinator {
        private let navigationController: UINavigationController
        private let recentDestinationsService: RecentDestinationsService
        private let destinationStore: DestinationStore
        private let destinationFetchingService: DestinationFetchingService

        init(navigationController: UINavigationController,
             recentDestinationsService: RecentDestinationsService,
             destinationStore: DestinationStore,
             destinationFetchingService: DestinationFetchingService) {
            self.navigationController = navigationController
            self.recentDestinationsService = recentDestinationsService
            self.destinationStore = destinationStore
            self.destinationFetchingService = destinationFetchingService
        }

        func start() {
            let viewController = DestinationListViewController(
                viewModel: .init(
                    recentDestinations: { [recentDestinationsService] in
                        recentDestinationsService.recentDestinations()
                    },
                    refreshRecentDestinations: destinationStore.refreshRecentDestinations.eraseToAnyPublisher(),
                    getDestinations: { [destinationFetchingService] in
                        let future = Future<Set<Destination>, DestinationFetchingServiceError> { promise in
                            destinationFetchingService.getDestinations { result in
                                switch result {
                                case .success(let destinations):
                                    promise(.success(destinations))
                                case .failure(let error):
                                    promise(.failure(error))
                                }
                            }
                        }
                        return future.eraseToAnyPublisher()
                    }
                )
            )
            viewController.coordinator = self
            navigationController.show(viewController, sender: self)
        }

        func showError(_ error: Error) {
            let alert = UIAlertController(
                title: "Erreur",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.view.tintColor = UIColor.evaneos(color: .veraneos)
            let action = UIAlertAction(
                title: "Annuler",
                style: .cancel
            )
            alert.addAction(action)

            navigationController.showDetailViewController(alert, sender: self)
        }
    }
}
