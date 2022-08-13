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

    func test_getDestinationDetails_setsTitleAndWebViewURLRequest() {
        // Given
        let expectation = XCTestExpectation(description: "destination details fetch occurs")
        
        let sut = DestinationDetailsController.ViewModel(
            getDestinationDetails: {
                expectation.fulfill()

                return Just(DestinationDetails.placeholder)
                    .setFailureType(to: DestinationFetchingServiceError.self)
                    .eraseToAnyPublisher()
            }
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
        
        wait(for: [expectation], timeout: 0.1)
    }

    func test_getDestinationDetails_triggersErrorPresentation_whenAnErrorOccurs() {
        // Given
        let sut = DestinationDetailsController.ViewModel(
            getDestinationDetails: {
                Fail(error: DestinationFetchingServiceError.destinationNotFound)
                    .eraseToAnyPublisher()
            }
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

        wait(for: [errorExpectation], timeout: 0.1)
    }
}
