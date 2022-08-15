//
//  DestinationsViewController.ViewModel.swift
//  DestinationGuide
//
//  Created by Bilal on 12/08/2022.
//

import Combine
import Foundation

protocol DestinationsViewModelIO {
    func recentDestinations() -> AnyPublisher<[DestinationDetails]?, Error>
    var refreshRecentDestinations: AnyPublisher<Void, Never> { get }
    func getDestinations() -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError>
}

extension DestinationsViewController {
    final class ViewModel {
        private let io: DestinationsViewModelIO
        private var cancellables: Set<AnyCancellable> = []

        @Published private(set) var sectionModels: [SectionModel]?
        @Published private var recentCellModels: [RecentDestinationCell.ViewModel]?
        @Published private var allCellModels: [DestinationCell.ViewModel]?

        private let presentErrorSubject = PassthroughSubject<Error, Never>()
        var presentError: AnyPublisher<Error, Never> {
            presentErrorSubject.eraseToAnyPublisher()
        }

        init(io: DestinationsViewModelIO) {
            self.io = io

            bindCellModels()
            bindRefreshRecentDestinations()
        }

        func loadDestinations() {
            loadRecentDestinations()
            getDestinations()
        }
    }
}

extension DestinationsViewController.ViewModel {
    convenience init(recentDestinations: @escaping () -> AnyPublisher<[DestinationDetails]?, Error>,
                     refreshRecentDestinations: AnyPublisher<Void, Never>,
                     getDestinations: @escaping () -> AnyPublisher<Set<Destination>, DestinationFetchingServiceError>) {
        self.init(
            io: AnyDestinationsViewModelIO(
                recentDestinations: recentDestinations,
                refreshRecentDestinations: refreshRecentDestinations,
                getDestinations: getDestinations
            )
        )
    }
}

private extension DestinationsViewController.ViewModel {
    func loadRecentDestinations() {
        io.recentDestinations()
            .receive(on: DispatchQueue.main)
            .`catch` { [presentErrorSubject] error -> Empty in
                presentErrorSubject.send(error)
                return Empty(completeImmediately: true)
            }
            .map {
                $0?
                    .sorted(by: { $0.name < $1.name })
                    .map(RecentDestinationCell.ViewModel.init(destinationDetails:))
            }
            .assign(to: &$recentCellModels)
    }

    func getDestinations() {
        io.getDestinations()
            .receive(on: DispatchQueue.main)
            .`catch` { [presentErrorSubject] error -> Empty in
                presentErrorSubject.send(error)
                return Empty(completeImmediately: true)
            }
            .map {
                Array($0)
                    .sorted(by: { $0.name < $1.name })
                    .map(DestinationCell.ViewModel.init(destination:))
            }
            .assign(to: &$allCellModels)
    }

    func bindCellModels() {
        $recentCellModels
            .combineLatest($allCellModels.compactMap { $0 })
            .map { recentCellModels, allCellModels in
                var sectionModels = [SectionModel]()

                if let recentCellModels = recentCellModels {
                    let sectionModel = SectionModel(
                        title: "Destinations récentes",
                        cellModels: recentCellModels
                    )
                    sectionModels.append(sectionModel)
                }

                let sectionModel = SectionModel(
                    title: "Toutes nos destinations",
                    cellModels: allCellModels
                )
                sectionModels.append(sectionModel)

                return sectionModels
            }
            .assign(to: &$sectionModels)
    }

    func bindRefreshRecentDestinations() {
        io.refreshRecentDestinations
            .sink { [weak self] in self?.loadRecentDestinations() }
            .store(in: &cancellables)
    }
}
