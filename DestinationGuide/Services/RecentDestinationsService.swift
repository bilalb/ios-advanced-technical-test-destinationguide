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

    func saveDestination(_ destination: DestinationDetails) throws {
        let destinationsArray = try recentDestinationsArray() ?? []
        if !destinationsArray.contains(destination) {
            let data = try encoder.encode(destination)
            var dataArray = userDefaults.array(forKey: key) ?? []
            dataArray.append(data)
            userDefaults.set(dataArray, forKey: key)
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
