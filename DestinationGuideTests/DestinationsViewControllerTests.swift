//
//  DestinationsViewControllerTests.swift
//  DestinationGuideTests
//
//  Created by Bilal on 12/08/2022.
//

@testable import DestinationGuide
import Combine
import XCTest

final class DestinationsViewControllerTests: XCTestCase {
    func test_fetchDestinations_onViewDidLoad() {
        // Given
        let expectation = XCTestExpectation(description: "send get destination request on viewDidLoad")

        let sut = DestinationsViewController(
            viewModel: .init(
                getDestinations: {
                    expectation.fulfill()

                    return Just([Destination.placeholder])
                        .setFailureType(to: DestinationFetchingServiceError.self)
                        .eraseToAnyPublisher()
                }
            )
        )

        // When
        sut.viewDidLoad()

        // Then
        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(expectation.expectedFulfillmentCount, 1)
    }
}
