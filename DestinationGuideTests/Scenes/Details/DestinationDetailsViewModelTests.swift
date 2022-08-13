//
//  DestinationDetailsViewModelTests.swift
//  DestinationGuideTests
//
//  Created by Bilal on 14/08/2022.
//

@testable import DestinationGuide
import Combine
import XCTest

final class DestinationDetailsViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func test_getDestinationDetails_setsTitleAndWebViewURLRequest_andSavesToRecent() {
        // Given
        let fetchExpectation = XCTestExpectation(description: "destination details fetch occurs")
        let saveExpectation = XCTestExpectation(description: "save to recent destinations occurs")

        let sut = DestinationDetailsController.ViewModel(
            getDestinationDetails: {
                fetchExpectation.fulfill()

                return Just(DestinationDetails.placeholder)
                    .setFailureType(to: DestinationFetchingServiceError.self)
                    .eraseToAnyPublisher()
            },
            saveDestination: { _ in saveExpectation.fulfill() }
        )
        
        // When
        sut.getDestinationDetails()
        
        // Then
        XCTAssertNil(sut.title)
        XCTAssertNil(sut.webViewURLRequest)

        DispatchQueue.main.async {
            XCTAssertEqual(sut.title, "Barbade")
            XCTAssertEqual(sut.webViewURLRequest?.url, URL(string:"https://evaneos.fr/barbade"))
        }
        
        wait(for: [fetchExpectation, saveExpectation], timeout: 0.1)
    }

    func test_getDestinationDetails_triggersErrorPresentation_whenAnErrorOccurs() {
        // Given
        let saveExpectation = XCTestExpectation(description: "save to recent destinations occurs")
        saveExpectation.isInverted = true

        let sut = DestinationDetailsController.ViewModel(
            getDestinationDetails: {
                Fail(error: DestinationFetchingServiceError.destinationNotFound)
                    .eraseToAnyPublisher()
            },
            saveDestination: { _ in saveExpectation.fulfill() }
        )

        let errorExpectation = XCTestExpectation(description: "error presentation gets triggered when an error occurs")

        // When
        sut.getDestinationDetails()

        // Then
        sut.presentError
            .sink { error in
                errorExpectation.fulfill()
                XCTAssertEqual(error as? DestinationFetchingServiceError, DestinationFetchingServiceError.destinationNotFound)
                XCTAssertNil(sut.title)
                XCTAssertNil(sut.webViewURLRequest)
            }
            .store(in: &cancellables)

        wait(for: [errorExpectation, saveExpectation], timeout: 0.1)
    }
}
