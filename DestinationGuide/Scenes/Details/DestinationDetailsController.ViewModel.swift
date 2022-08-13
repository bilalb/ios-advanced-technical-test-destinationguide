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
}

extension DestinationDetailsController {
    final class ViewModel {
        private let io: DestinationDetailsViewModelIO

        private let presentErrorSubject = PassthroughSubject<Error, Never>()
        var presentError: AnyPublisher<Error, Never> {
            presentErrorSubject.eraseToAnyPublisher()
        }

        @Published private(set) var title: String?
        @Published private(set) var webViewURLRequest: URLRequest?

        init(io: DestinationDetailsViewModelIO) {
            self.io = io
        }

        func getDestinationDetails() {
            let publisher = io.getDestinationDetails()
                .receive(on: DispatchQueue.main)
                .`catch` { [presentErrorSubject] error -> Empty<DestinationDetails, Never> in
                    presentErrorSubject.send(error)
                    return Empty(completeImmediately: true)
                }
                .share()

            publisher
                .map { $0.name }
                .assign(to: &$title)

            publisher
                .map(\.url)
                .map { URLRequest(url: $0) }
                .assign(to: &$webViewURLRequest)
        }
    }
}

extension DestinationDetailsController.ViewModel {
    convenience init(getDestinationDetails: @escaping () -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError>) {
        self.init(
            io: AnyDestinationDetailsViewModelIO(
                getDestinationDetails: getDestinationDetails
            )
        )
    }
}
