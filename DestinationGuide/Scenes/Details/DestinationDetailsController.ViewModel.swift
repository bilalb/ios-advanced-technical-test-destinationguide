//
//  DestinationDetailsController.ViewModel.swift
//  DestinationGuide
//
//  Created by Bilal on 13/08/2022.
//

import Combine
import Foundation

protocol DestinationDetailsViewModelIO {
    func getDestinationDetails() -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError>
    func saveDestination(_ destinationDetails: DestinationDetails) throws
}

extension DestinationDetailsController {
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

        private func bindDestinationDetails() {
            $destinationDetails
                .map { $0?.name }
                .assign(to: &$title)

            $destinationDetails
                .compactMap(\.?.url)
                .map { URLRequest(url: $0) }
                .assign(to: &$webViewURLRequest)

            $destinationDetails
                .compactMap { $0 }
                .sink { [io] in try? io.saveDestination($0) }
                .store(in: &cancellables)
        }
    }
}

extension DestinationDetailsController.ViewModel {
    convenience init(getDestinationDetails: @escaping () -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError>,
                     saveDestination: @escaping (DestinationDetails) throws -> Void) {
        self.init(
            io: AnyDestinationDetailsViewModelIO(
                getDestinationDetails: getDestinationDetails,
                saveDestination: saveDestination
            )
        )
    }
}