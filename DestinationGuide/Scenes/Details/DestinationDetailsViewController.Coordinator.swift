//
//  DestinationDetailsViewController.Coordinator.swift
//  DestinationGuide
//
//  Created by Bilal on 16/08/2022.
//

import Combine
import UIKit

extension DestinationDetailsViewController {
    final class Coordinator: DestinationGuide.Coordinator {
        private let navigationController: UINavigationController
        private let destinationFetchingService: DestinationFetchingService
        private let destinationID: Destination.ID
        private let recentDestinationsService: RecentDestinationsService
        private let destinationStore: DestinationStore

        init(navigationController: UINavigationController,
             destinationFetchingService: DestinationFetchingService,
             destinationID: Destination.ID,
             recentDestinationsService: RecentDestinationsService,
             destinationStore: DestinationStore) {
            self.navigationController = navigationController
            self.destinationFetchingService = destinationFetchingService
            self.destinationID = destinationID
            self.recentDestinationsService = recentDestinationsService
            self.destinationStore = destinationStore
        }

        func start() {
            let viewController = DestinationDetailsViewController(
                viewModel: .init(
                    getDestinationDetails: { [destinationFetchingService, destinationID] in
                        destinationFetchingService.getDestinationDetailsPublisher(for: destinationID)
                    },
                    saveDestination: { [recentDestinationsService] destination in
                        try recentDestinationsService.saveDestination(destination)
                    },
                    saveCompletedSubject: destinationStore.refreshRecentDestinations
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
