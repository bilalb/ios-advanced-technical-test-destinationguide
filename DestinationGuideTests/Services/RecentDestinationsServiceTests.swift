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
    private var sut: RecentDestinationsService!

    override func setUp() {
        let userDefaults = UserDefaults(suiteName: #file)!
        userDefaults.removePersistentDomain(forName: #file)

        sut = RecentDestinationsService(
            userDefaults: userDefaults,
            encoder: .init(),
            decoder: .init()
        )
    }

    func test_saveDestination_avoidsDuplicates() throws {
        XCTAssertNil(try sut.recentDestinations())

        // When
        var addedToRecentDestinations = try sut.saveDestination(.placeholder)

        // Then
        XCTAssertEqual(try sut.recentDestinations()?.count, 1)
        XCTAssertEqual(try sut.recentDestinations()?.first?.name, "Barbade")
        XCTAssertTrue(addedToRecentDestinations)

        addedToRecentDestinations = try sut.saveDestination(.placeholder)
        XCTAssertEqual(try sut.recentDestinations()?.count, 1)
        XCTAssertFalse(addedToRecentDestinations)
    }
}
