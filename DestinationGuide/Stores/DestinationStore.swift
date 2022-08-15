//
//  DestinationStore.swift
//  DestinationGuide
//
//  Created by Bilal on 14/08/2022.
//

import Combine

final class DestinationStore {
    static let shared = DestinationStore()
    let refreshRecentDestinations = PassthroughSubject<Void, Never>()

    private init() {}
}
