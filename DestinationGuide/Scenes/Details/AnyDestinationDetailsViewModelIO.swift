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

    init(getDestinationDetails: @escaping () -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError>) {
        _getDestinationDetails = getDestinationDetails
    }

    func getDestinationDetails() -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError> {
        _getDestinationDetails()
    }
}
