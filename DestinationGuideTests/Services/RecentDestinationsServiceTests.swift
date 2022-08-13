//
//  RecentDestinationsServiceTests.swift
//  DestinationGuideTests
//
//  Created by Bilal on 14/08/2022.
//

@testable import DestinationGuide
import Combine
import XCTest

final class RecentDestinationsServiceTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var encoder: JSONEncoder!
    private var decoder: JSONDecoder!
    private var key: String!
    private var sut: RecentDestinationsService!

    override func setUp() {
        userDefaults = UserDefaults(suiteName: #file)!
        userDefaults.removePersistentDomain(forName: #file)

        encoder = JSONEncoder()
        decoder = JSONDecoder()
        key = "recentDestinations"

        sut = RecentDestinationsService(
            userDefaults: userDefaults,
            encoder: encoder,
            decoder: decoder
        )
    }

    func test_saveDestination_avoidsDuplicates() throws {
        // When
        try sut.saveDestination(.placeholder)

        // Then
        XCTAssertEqual(try recentDestinationsArray()?.count, 1)
        XCTAssertEqual(try recentDestinationsArray()?.first?.name, "Barbade")

        try sut.saveDestination(.placeholder)
        XCTAssertEqual(try recentDestinationsArray()?.count, 1)
    }
}

private extension RecentDestinationsServiceTests {
    func recentDestinationsArray() throws -> [DestinationDetails]? {
        let dataArray = userDefaults.array(forKey: key) as? [Data]
        return try dataArray?.map { data -> DestinationDetails in
            return try decoder.decode(DestinationDetails.self, from: data)
        }
    }
}
