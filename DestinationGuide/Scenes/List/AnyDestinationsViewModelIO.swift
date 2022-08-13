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
    private let _getDestinationDetails: (Destination.ID) -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError>

    init(getDestinations: @escaping () -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError>,
         getDestinationDetails: @escaping (Destination.ID) -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError>) {
        _getDestinations = getDestinations
        _getDestinationDetails = getDestinationDetails
    }

    func getDestinations() -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError> {
        _getDestinations()
    }

    func getDestinationDetails(for id: Destination.ID) -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError> {
        _getDestinationDetails(id)
    }
}
