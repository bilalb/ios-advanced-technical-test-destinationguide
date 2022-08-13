//
//  DestinationsViewModelTests.swift
//  DestinationGuideTests
//
//  Created by Bilal on 12/08/2022.
//

@testable import DestinationGuide
import Combine
import XCTest

final class DestinationsViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func test_getDestinations_sortsResponse() {
        // Given
        let first = Destination(id: "217", name: "A", picture: URL(string:"https://static1.evcdn.net/images/reduction/1027399_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5)

        let second = Destination(id: "217", name: "Z", picture: URL(string:"https://static1.evcdn.net/images/reduction/1027399_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5)

        let sut = DestinationsViewController.ViewModel(
            getDestinations: {
                Just([first, second])
                    .setFailureType(to: DestinationFetchingServiceError.self)
                    .eraseToAnyPublisher()
            },
            getDestinationDetails: { _ in
                Empty(completeImmediately: true, outputType: DestinationDetails.self, failureType: DestinationFetchingServiceError.self)
                    .eraseToAnyPublisher()
            }
        )

        // When
        sut.getDestinations()

        // Then
        XCTAssertNil(sut.cellModels)

        DispatchQueue.main.async {
            XCTAssertNotNil(sut.cellModels)
            XCTAssertEqual(sut.cellModels?.count, 2)
            XCTAssertEqual(sut.cellModels?.first?.name, "A")
        }
    }

    func test_getDestinations_triggersErrorPresentation_whenAnErrorOccurs() {
        // Given
        let sut = DestinationsViewController.ViewModel(
            getDestinations: {
                Fail(error: DestinationFetchingServiceError.destinationNotFound)
                    .eraseToAnyPublisher()
            },
            getDestinationDetails: { _ in
                Empty(completeImmediately: true, outputType: DestinationDetails.self, failureType: DestinationFetchingServiceError.self)
                    .eraseToAnyPublisher()
            }
        )

        let expectation = XCTestExpectation(description: "error presentation gets triggered when an error occurs")

        // When
        sut.getDestinations()

        // Then
        XCTAssertNil(sut.cellModels)

        sut.presentError
            .sink { error in
                expectation.fulfill()
                XCTAssertEqual(error as? DestinationFetchingServiceError, DestinationFetchingServiceError.destinationNotFound)
                XCTAssertNil(sut.cellModels)
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
    }

    func test_getDestinationDetails() {
        // Given
        let expectation = XCTestExpectation(description: "destination details fetch occurs")

        let sut = DestinationsViewController.ViewModel(
            getDestinations: {
                Empty(completeImmediately: true, outputType: Set<Destination>.self, failureType: DestinationFetchingServiceError.self)
                    .eraseToAnyPublisher()
            },
            getDestinationDetails: { id in
                expectation.fulfill()
                XCTAssertEqual(id, "42")

                return Just(DestinationDetails.placeholder)
                    .setFailureType(to: DestinationFetchingServiceError.self)
                    .eraseToAnyPublisher()
            }
        )

        // When
        sut.getDestinationDetails(for: "42")

        // Then
        XCTAssertNil(sut.cellModels)
        XCTAssertNil(sut.destinationDetails)

        DispatchQueue.main.async {
            XCTAssertNil(sut.cellModels)
            XCTAssertNotNil(sut.destinationDetails)
        }

        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(expectation.expectedFulfillmentCount, 1)
    }
}
