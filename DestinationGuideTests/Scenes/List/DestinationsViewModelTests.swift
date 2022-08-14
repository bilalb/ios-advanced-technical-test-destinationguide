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

    func test_loadDestinations_sortsResponse() {
        // Given
        let first = Destination(id: "217", name: "A", picture: URL(string:"https://static1.evcdn.net/images/reduction/1027399_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5)

        let second = Destination(id: "217", name: "Z", picture: URL(string:"https://static1.evcdn.net/images/reduction/1027399_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5)

        let sut = DestinationsViewController.ViewModel(
            recentDestinations: {
                Just([.placeholder])
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            refreshRecentDestinations: PassthroughSubject<Void, Never>().eraseToAnyPublisher(),
            getDestinations: {
                Just([first, second])
                    .setFailureType(to: DestinationFetchingServiceError.self)
                    .eraseToAnyPublisher()
            }
        )

        // When
        sut.loadDestinations()

        // Then
        XCTAssertNil(sut.sectionModels)

        DispatchQueue.main.async {
            XCTAssertNotNil(sut.sectionModels)
            XCTAssertEqual(sut.sectionModels?.count, 2)

            XCTAssertEqual(sut.sectionModels?.first?.title, "Destinations récentes")
            XCTAssertEqual(sut.sectionModels?.first?.cellModels.count, 1)
            XCTAssertEqual(sut.sectionModels?.first?.cellModels.first?.id, "217")

            XCTAssertEqual(sut.sectionModels?[1].title, "Toutes nos destinations")
            XCTAssertEqual(sut.sectionModels?[1].cellModels.count, 2)
            XCTAssertEqual((sut.sectionModels?[1].cellModels.first as? DestinationCell.ViewModel)?.name, "A")
            XCTAssertEqual((sut.sectionModels?[1].cellModels[1] as? DestinationCell.ViewModel)?.name, "Z")
        }
    }

    func test_loadDestinations_withoutRecentSection() {
        // Given
        let sut = DestinationsViewController.ViewModel(
            recentDestinations: {
                Just(nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            refreshRecentDestinations: PassthroughSubject<Void, Never>().eraseToAnyPublisher(),
            getDestinations: {
                Just([.placeholder])
                    .setFailureType(to: DestinationFetchingServiceError.self)
                    .eraseToAnyPublisher()
            }
        )

        // When
        sut.loadDestinations()

        // Then
        XCTAssertNil(sut.sectionModels)

        DispatchQueue.main.async {
            XCTAssertNotNil(sut.sectionModels)
            XCTAssertEqual(sut.sectionModels?.count, 1)

            XCTAssertEqual(sut.sectionModels?.first?.title, "Toutes nos destinations")
        }
    }

    func test_loadDestinations_triggersErrorPresentation_whenAnErrorOccurs() {
        // Given
        let sut = DestinationsViewController.ViewModel(
            recentDestinations: {
                Just([.placeholder])
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            refreshRecentDestinations: PassthroughSubject<Void, Never>().eraseToAnyPublisher(),
            getDestinations: {
                Fail(error: DestinationFetchingServiceError.destinationNotFound)
                    .eraseToAnyPublisher()
            }
        )

        let expectation = XCTestExpectation(description: "error presentation gets triggered when an error occurs")

        // When
        sut.loadDestinations()

        // Then
        XCTAssertNil(sut.sectionModels)

        sut.presentError
            .sink { error in
                expectation.fulfill()
                XCTAssertEqual(error as? DestinationFetchingServiceError, DestinationFetchingServiceError.destinationNotFound)
                XCTAssertNil(sut.sectionModels)
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.1)
    }

    func test_refreshRecentDestinations() {
        // Given
        let expectation = XCTestExpectation(description: "load recent destinations")

        let refreshRecentDestinations = PassthroughSubject<Void, Never>()

        let sut = DestinationsViewController.ViewModel(
            recentDestinations: {
                expectation.fulfill()
                return Just(nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            refreshRecentDestinations: refreshRecentDestinations.eraseToAnyPublisher(),
            getDestinations: { fatalError("getDestinations should not be called when refreshing recent destinations") }
        )

        // When
        refreshRecentDestinations.send()

        // Then
        wait(for: [expectation], timeout: 0.1)
    }
}
