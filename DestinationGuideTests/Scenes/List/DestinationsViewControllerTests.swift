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
    func test_loadsDestinations_onViewDidLoad() {
        // Given
        let recentDestinationsExpectation = XCTestExpectation(description: "loads recent destinations")
        let getDestinationsExpectation = XCTestExpectation(description: "gets destinations")

        let sut = DestinationsViewController(
            viewModel: .init(
                recentDestinations: {
                    recentDestinationsExpectation.fulfill()

                    return Just([.placeholder])
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                },
                refreshRecentDestinations: PassthroughSubject<Void, Never>().eraseToAnyPublisher(),
                getDestinations: {
                    getDestinationsExpectation.fulfill()

                    return Just([.placeholder])
                        .setFailureType(to: DestinationFetchingServiceError.self)
                        .eraseToAnyPublisher()
                }
            )
        )

        // When
        sut.viewDidLoad()

        // Then
        wait(for: [recentDestinationsExpectation, getDestinationsExpectation], timeout: 0.1)
    }
}
