//
//  DestinationListViewModelTests.swift
//  DestinationGuideTests
//
//  Created by Bilal on 12/08/2022.
//

@testable import DestinationGuide
import Combine
import XCTest

final class DestinationListViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func test_loadDestinations_sortsResponse() {
        // Given
        let first = Destination(id: "217", name: "A", picture: URL(string:"https://static1.evcdn.net/images/reduction/1027399_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5)

        let second = Destination(id: "217", name: "Z", picture: URL(string:"https://static1.evcdn.net/images/reduction/1027399_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5)

        let sut = DestinationListViewController.ViewModel(
            recentDestinations: { [.placeholder] },
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
        let sut = DestinationListViewController.ViewModel(
            recentDestinations: { nil },
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
        let sut = DestinationListViewController.ViewModel(
            recentDestinations: { [.placeholder] },
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
        let recentDestinationsExpectation = XCTestExpectation(description: "load recent destinations")

        let getDestinationsExpectation = XCTestExpectation(description: "get destinations")
        getDestinationsExpectation.isInverted = true

        let refreshRecentDestinations = PassthroughSubject<Void, Never>()

        let sut = DestinationListViewController.ViewModel(
            recentDestinations: {
                recentDestinationsExpectation.fulfill()
                return nil
            },
            refreshRecentDestinations: refreshRecentDestinations.eraseToAnyPublisher(),
            getDestinations: {
                getDestinationsExpectation.fulfill()
                return Fail(error: DestinationFetchingServiceError.destinationNotFound)
                    .eraseToAnyPublisher()
            }
        )

        // When
        refreshRecentDestinations.send()

        // Then
        wait(for: [recentDestinationsExpectation, getDestinationsExpectation], timeout: 0.1)
    }
}
