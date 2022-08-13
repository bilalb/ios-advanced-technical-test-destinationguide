//
//  AnyDestinationsViewModelIO.swift
//  DestinationGuide
//
//  Created by Bilal on 12/08/2022.
//

import Combine
import Foundation

struct AnyDestinationsViewModelIO: DestinationsViewModelIO {
    private let _getDestinations: () -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError>

    init(getDestinations: @escaping () -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError>) {
        _getDestinations = getDestinations
    }

    func getDestinations() -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError> {
        _getDestinations()
    }
}
