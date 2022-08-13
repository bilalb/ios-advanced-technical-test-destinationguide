//
//  DestinationsViewController.ViewModel.swift
//  DestinationGuide
//
//  Created by Bilal on 12/08/2022.
//

import Combine
import Foundation

protocol DestinationsViewModelIO {
    func getDestinations() -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError>
}

extension DestinationsViewController {
    final class ViewModel {
        private let io: DestinationsViewModelIO

        @Published private(set) var cellModels: [DestinationCell.ViewModel]?

        private let presentErrorSubject = PassthroughSubject<Error, Never>()
        var presentError: AnyPublisher<Error, Never> {
            presentErrorSubject.eraseToAnyPublisher()
        }

        init(io: DestinationsViewModelIO) {
            self.io = io
        }

        func getDestinations() {
            io.getDestinations()
                .receive(on: DispatchQueue.main)
                .`catch` { [presentErrorSubject] error -> Empty in
                    presentErrorSubject.send(error)
                    return Empty(completeImmediately: true)
                }
                .map {
                    Array($0)
                        .sorted(by: { $0.name < $1.name })
                        .map(DestinationCell.ViewModel.init(destination:))
                }
                .assign(to: &$cellModels)
        }
    }
}

extension DestinationsViewController.ViewModel {
    convenience init(getDestinations: @escaping () -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError>) {
        self.init(
            io: AnyDestinationsViewModelIO(
                getDestinations: getDestinations
            )
        )
    }
}
