//
//  AnyDestinationsViewModelIO.swift
//  DestinationGuide
//
//  Created by Bilal on 12/08/2022.
//

import Combine
import Foundation

struct AnyDestinationsViewModelIO: DestinationsViewModelIO {
    private let _recentDestinations: () -> AnyPublisher<[DestinationDetails]?, Error>
    let refreshRecentDestinations: AnyPublisher<Void, Never>
    private let _getDestinations: () -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError>

    init(recentDestinations: @escaping () -> AnyPublisher<[DestinationDetails]?, Error>,
         refreshRecentDestinations: AnyPublisher<Void, Never>,
         getDestinations: @escaping () -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError>) {
        _recentDestinations = recentDestinations
        self.refreshRecentDestinations = refreshRecentDestinations
        _getDestinations = getDestinations
    }

    func recentDestinations() -> AnyPublisher<[DestinationDetails]?, Error> {
        _recentDestinations()
    }

    func getDestinations() -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError> {
        _getDestinations()
    }
}
