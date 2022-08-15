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
            saveDestination: { _ in
                saveExpectation.fulfill()
                return true
            },
            saveCompletedSubject: .init()
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

        let saveCompletedExpectation = XCTestExpectation(description: "save completed is triggered")
        saveCompletedExpectation.isInverted = true

        let saveCompletedSubject = PassthroughSubject<Void, Never>()

        let sut = DestinationDetailsController.ViewModel(
            getDestinationDetails: {
                Fail(error: DestinationFetchingServiceError.destinationNotFound)
                    .eraseToAnyPublisher()
            },
            saveDestination: { _ in
                saveExpectation.fulfill()
                return true
            },
            saveCompletedSubject: saveCompletedSubject
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

        saveCompletedSubject
            .sink { saveCompletedExpectation.fulfill() }
            .store(in: &cancellables)

        let expectations = [
            errorExpectation,
            saveExpectation,
            saveCompletedExpectation
        ]
        wait(for: expectations, timeout: 0.1)
    }

    func test_saveCompleted_isTriggeredWhenDestinationIsSaved() {
        // Given
        let saveCompletedExpectation = XCTestExpectation(description: "save completed is triggered")

        let saveCompletedSubject = PassthroughSubject<Void, Never>()

        let sut = DestinationDetailsController.ViewModel(
            getDestinationDetails: {
                return Just(DestinationDetails.placeholder)
                    .setFailureType(to: DestinationFetchingServiceError.self)
                    .eraseToAnyPublisher()
            },
            saveDestination: { _ in true },
            saveCompletedSubject: saveCompletedSubject
        )

        // When
        sut.getDestinationDetails()

        // Then
        saveCompletedSubject
            .sink { saveCompletedExpectation.fulfill() }
            .store(in: &cancellables)

        wait(for: [saveCompletedExpectation], timeout: 0.1)
    }

    func test_saveCompleted_isNotTriggeredWhenDestinationIsNotSaved() {
        // Given
        let saveCompletedExpectation = XCTestExpectation(description: "save completed is triggered")
        saveCompletedExpectation.isInverted = true

        let saveCompletedSubject = PassthroughSubject<Void, Never>()

        let sut = DestinationDetailsController.ViewModel(
            getDestinationDetails: {
                return Just(DestinationDetails.placeholder)
                    .setFailureType(to: DestinationFetchingServiceError.self)
                    .eraseToAnyPublisher()
            },
            saveDestination: { _ in false },
            saveCompletedSubject: saveCompletedSubject
        )

        // When
        sut.getDestinationDetails()

        // Then
        saveCompletedSubject
            .sink { saveCompletedExpectation.fulfill() }
            .store(in: &cancellables)

        wait(for: [saveCompletedExpectation], timeout: 0.1)
    }
}
