//
//  AnyDestinationListViewModelIO.swift
//  DestinationGuide
//
//  Created by Bilal on 12/08/2022.
//

import Combine
import Foundation

struct AnyDestinationListViewModelIO: DestinationListViewModelIO {
    private let _recentDestinations: () throws -> [DestinationDetails]?
    let refreshRecentDestinations: AnyPublisher<Void, Never>
    private let _getDestinations: () -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError>

    init(recentDestinations: @escaping () throws -> [DestinationDetails]?,
         refreshRecentDestinations: AnyPublisher<Void, Never>,
         getDestinations: @escaping () -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError>) {
        _recentDestinations = recentDestinations
        self.refreshRecentDestinations = refreshRecentDestinations
        _getDestinations = getDestinations
    }

    func recentDestinations() throws -> [DestinationDetails]? {
        try _recentDestinations()
    }

    func getDestinations() -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError> {
        _getDestinations()
    }
}
