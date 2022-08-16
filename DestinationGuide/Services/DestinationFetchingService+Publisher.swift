//
//  DestinationFetchingService+Publisher.swift
//  DestinationGuide
//
//  Created by Bilal on 16/08/2022.
//

import Combine

extension DestinationFetchingService {
    func getDestinationsPublisher() -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError> {
        let future = Future<Set<Destination>, DestinationFetchingServiceError> { [weak self] promise in
            self?.getDestinations { result in
                switch result {
                case .success(let destinations):
                    promise(.success(destinations))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        return future.eraseToAnyPublisher()
    }

    func getDestinationDetailsPublisher(for destinationID: Destination.ID) -> AnyPublisher<DestinationDetails, DestinationFetchingServiceError> {
        let future = Future<DestinationDetails, DestinationFetchingServiceError> { [weak self] promise in
            self?.getDestinationDetails(for: destinationID) { result in
                switch result {
                case .success(let destinationDetails):
                    promise(.success(destinationDetails))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        return future.eraseToAnyPublisher()
    }
}
