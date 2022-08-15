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
    private let _saveDestination: (DestinationDetails) throws -> Bool
    let saveCompletedSubject: PassthroughSubject<Void, Never>

    init(getDestinationDetails: @escaping () -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError>,
         saveDestination: @escaping (DestinationDetails) throws -> Bool,
         saveCompletedSubject: PassthroughSubject<Void, Never>) {
        _getDestinationDetails = getDestinationDetails
        _saveDestination = saveDestination
        self.saveCompletedSubject = saveCompletedSubject
    }

    func getDestinationDetails() -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError> {
        _getDestinationDetails()
    }

    func saveDestination(_ destinationDetails: DestinationDetails) throws -> Bool {
        try _saveDestination(destinationDetails)
    }
}
