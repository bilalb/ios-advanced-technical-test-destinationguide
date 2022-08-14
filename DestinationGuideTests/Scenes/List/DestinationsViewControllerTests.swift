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
    private var cancellables: Set<AnyCancellable> = []

    func test_loadsDestinations_onViewDidLoad() {
        // Given
        let recentDestinationsExpectation = XCTestExpectation(description: "loads recent destinations")

        let refreshExpectation = XCTestExpectation(description: "refresh destinations")
        refreshExpectation.isInverted = true

        let refreshRecentDestinations = PassthroughSubject<Void, Never>()

        let getDestinationsExpectation = XCTestExpectation(description: "gets destinations")

        let sut = DestinationsViewController(
            viewModel: .init(
                recentDestinations: {
                    recentDestinationsExpectation.fulfill()

                    return Just([.placeholder])
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                },
                refreshRecentDestinations: refreshRecentDestinations.eraseToAnyPublisher(),
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
        refreshRecentDestinations
            .sink { refreshExpectation.fulfill() }
            .store(in: &cancellables)

        let expectations = [
            recentDestinationsExpectation,
            getDestinationsExpectation,
            refreshExpectation
        ]
        wait(for: expectations, timeout: 0.1)
    }
}
