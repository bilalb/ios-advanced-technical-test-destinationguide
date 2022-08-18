//
//  DestinationDetailsViewController.ViewModel.swift
//  DestinationGuide
//
//  Created by Bilal on 13/08/2022.
//

import Combine
import Foundation

protocol DestinationDetailsViewModelIO {
    func getDestinationDetails() -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError>
    func saveDestination(_ destinationDetails: DestinationDetails) throws -> Bool
    var saveCompletedSubject: PassthroughSubject<Void, Never> { get }
}

extension DestinationDetailsViewController {
    final class ViewModel {
        private let io: DestinationDetailsViewModelIO
        private var cancellables: Set<AnyCancellable> = []

        private let presentErrorSubject = PassthroughSubject<Error, Never>()
        var presentError: AnyPublisher<Error, Never> {
            presentErrorSubject.eraseToAnyPublisher()
        }

        @Published private var destinationDetails: DestinationDetails?
        @Published private(set) var title: String?
        @Published private(set) var webViewURLRequest: URLRequest?

        init(io: DestinationDetailsViewModelIO) {
            self.io = io

            bindDestinationDetails()
        }

        func getDestinationDetails() {
            io.getDestinationDetails()
                .receive(on: DispatchQueue.main)
                .`catch` { [presentErrorSubject] error -> Empty<DestinationDetails, Never> in
                    presentErrorSubject.send(error)
                    return Empty(completeImmediately: true)
                }
                .map { $0 }
                .assign(to: &$destinationDetails)
        }
    }
}

extension DestinationDetailsViewController.ViewModel {
    convenience init(getDestinationDetails: @escaping () -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError>,
                     saveDestination: @escaping (DestinationDetails) throws -> Bool,
                     saveCompletedSubject: PassthroughSubject<Void, Never>) {
        self.init(
            io: AnyDestinationDetailsViewModelIO(
                getDestinationDetails: getDestinationDetails,
                saveDestination: saveDestination,
                saveCompletedSubject: saveCompletedSubject
            )
        )
    }
}

// MARK: - Private Bindings Methods

private extension DestinationDetailsViewController.ViewModel {
    func bindDestinationDetails() {
        $destinationDetails
            .map(\.?.name)
            .assign(to: &$title)

        $destinationDetails
            .compactMap(\.?.url)
            .map { URLRequest(url: $0) }
            .assign(to: &$webViewURLRequest)

        $destinationDetails
            .compactMap { $0 }
            .sink { [io] in
                let addedToRecentDestinations = try? io.saveDestination($0)
                if addedToRecentDestinations == true {
                    io.saveCompletedSubject.send()
                }
            }
            .store(in: &cancellables)
    }
}
