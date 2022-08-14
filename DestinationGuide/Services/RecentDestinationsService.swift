//
//  RecentDestinationsService.swift
//  DestinationGuide
//
//  Created by Bilal on 14/08/2022.
//

import Combine
import Foundation

struct RecentDestinationsService {
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let key = "recentDestinations"

    init(userDefaults: UserDefaults = .standard,
         encoder: JSONEncoder = .init(),
         decoder: JSONDecoder = .init()) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }

    /// Saves to recent destinations.
    ///
    /// Duplicated destinations are not saved.
    /// - Parameter destination: The destination to save to recent destinations
    /// - Returns: `true` if the destination is not duplicated and added to recent destinations. Otherwise `false`.
    func saveDestination(_ destination: DestinationDetails) throws -> Bool {
        let destinationsArray = try recentDestinationsArray() ?? []
        if !destinationsArray.contains(destination) {
            let data = try encoder.encode(destination)
            var dataArray = userDefaults.array(forKey: key) ?? []
            dataArray.append(data)
            userDefaults.set(dataArray, forKey: key)
            return true
        } else {
            return false
        }
    }

    func recentDestinations() -> AnyPublisher<[DestinationDetails]?, Error> {
        do {
            let recentDestinations = try recentDestinationsArray()
            return Just(recentDestinations)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}

private extension RecentDestinationsService {
    func recentDestinationsArray() throws -> [DestinationDetails]? {
        let dataArray = userDefaults.array(forKey: key) as? [Data]
        return try dataArray?.map { data -> DestinationDetails in
            return try decoder.decode(DestinationDetails.self, from: data)
        }
    }
}
