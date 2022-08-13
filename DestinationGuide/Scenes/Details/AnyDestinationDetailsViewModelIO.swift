//
//  AnyDestinationDetailsViewModelIO.swift
//  DestinationGuide
//
//  Created by Bilal on 13/08/2022.
//

import Combine
import Foundation

struct AnyDestinationDetailsViewModelIO: DestinationDetailsViewModelIO {
    private let _getDestinationDetails: () -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError>
    private let _saveDestination: (DestinationDetails) throws -> Void

    init(getDestinationDetails: @escaping () -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError>,
         saveDestination: @escaping (DestinationDetails) throws -> Void) {
        _getDestinationDetails = getDestinationDetails
        _saveDestination = saveDestination
    }

    func getDestinationDetails() -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError> {
        _getDestinationDetails()
    }

    func saveDestination(_ destinationDetails: DestinationDetails) throws {
        try _saveDestination(destinationDetails)
    }
}
