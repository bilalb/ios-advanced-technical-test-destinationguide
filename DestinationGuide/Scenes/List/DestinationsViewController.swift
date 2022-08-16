//
//  DestinationsViewController.swift
//  DestinationGuide
//
//  Created by Alexandre Guibert1 on 02/08/2021.
//

import Combine
import UIKit

final class DestinationsViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    private let viewModel: ViewModel
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 48

        return UICollectionViewCompositionalLayout(
            sectionProvider: { [weak self] sectionIndex, _ in
                let cellModel = self?.viewModel.sectionModels?[sectionIndex].cellModels.first

                switch cellModel {
                case is RecentDestinationCell.ViewModel:
                    return self?.makeRecentSection()
                case is DestinationCell.ViewModel:
                    return self?.makeAllSection()
                case is NoSearchResultCell.ViewModel:
                    return self?.makeNoResultSection()
                default:
                    preconditionFailure("unknown cellModel: \(String(describing: cellModel))")
                }
            },
            configuration: configuration
        )
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: self.collectionViewLayout)
        collectionView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            RecentDestinationCell.self,
            forCellWithReuseIdentifier: RecentDestinationCell.reuseIdentifier
        )
        collectionView.register(
            DestinationCell.self,
            forCellWithReuseIdentifier: DestinationCell.reuseIdentifier
        )
        collectionView.register(
            NoSearchResultCell.self,
            forCellWithReuseIdentifier: NoSearchResultCell.reuseIdentifier
        )
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor.evaneos(color: .veraneos)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Destinations"

        navigationController?.navigationBar.tintColor = UIColor.evaneos(color: .veraneos)

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.frame = view.frame
        collectionView.dataSource = self

        view.addSubview(activityIndicator)
        activityIndicator.center = view.center

        bindViewModel()
        viewModel.loadDestinations()
    }
}

// MARK: - Private Binding Methods

private extension DestinationsViewController {
    func bindViewModel() {
        viewModel.presentError
            .sink { [weak self, activityIndicator] error in
                activityIndicator.stopAnimating()

                let alert = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                alert.view.tintColor = UIColor.evaneos(color: .veraneos)
                alert.addAction(UIAlertAction(title: "Annuler", style: .cancel))

                self?.showDetailViewController(alert, sender: self)
            }
            .store(in: &cancellables)

        viewModel.$sectionModels
            .compactMap { $0 }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [collectionView, activityIndicator] _ in
                collectionView.reloadData()
                activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // Get the view for the first header
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        // Use this view to calculate the optimal size based on the collection view's width
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
    }
}

// MARK: - Private Collection View Layout Methods

private extension DestinationsViewController {
    func makeRecentSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1),
            heightDimension: .estimated(37)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [makeSectionHeader()]
        section.contentInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16

        return section
    }

    func makeAllSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(280)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [makeSectionHeader()]
        section.contentInsets = .init(top: 16, leading: 16, bottom: 32, trailing: 16)
        section.interGroupSpacing = 32

        return section
    }

    func makeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(30)
        )

        return .init(
            layoutSize: layoutSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }

    func makeNoResultSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(37)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [makeSectionHeader()]
        section.contentInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)

        return section
    }
}

// MARK: - UICollectionViewDataSource

extension DestinationsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sectionModels?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sectionModels?[section].cellModels.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = viewModel.sectionModels?[indexPath.section].cellModels[indexPath.row]

        switch cellModel {
        case let cellModel as RecentDestinationCell.ViewModel:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentDestinationCell.reuseIdentifier, for: indexPath) as? RecentDestinationCell {
                cell.setupCell(viewModel: cellModel)
                return cell
            }
        case let cellModel as DestinationCell.ViewModel:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DestinationCell.reuseIdentifier, for: indexPath) as? DestinationCell {
                cell.setupCell(viewModel: cellModel)
                return cell
            }
        case is NoSearchResultCell.ViewModel:
            return collectionView.dequeueReusableCell(withReuseIdentifier: NoSearchResultCell.reuseIdentifier, for: indexPath)
        default:
            break
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as! SectionHeader
            let sectionModel = viewModel.sectionModels?[indexPath.section]
            headerView.titleLabel.text = sectionModel?.title
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

// MARK: - UICollectionViewDelegate

extension DestinationsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellModel = viewModel.sectionModels?[indexPath.section].cellModels[indexPath.row] else {
            print("Unable to react to item selection at: \(indexPath), because the item does not have any related destination.")
            return
        }

        let viewController = DestinationDetailsController(
            viewModel: .init(
                getDestinationDetails: {
                    let future = Future<DestinationDetails, DestinationFetchingServiceError> { promise in
                        DestinationFetchingService().getDestinationDetails(for: cellModel.id) { result in
                            switch result {
                            case .success(let destinationDetails):
                                promise(.success(destinationDetails))
                            case .failure(let error):
                                promise(.failure(error))
                            }
                        }
                    }
                    return future.eraseToAnyPublisher()
                },
                saveDestination: { destination in
                    let service = RecentDestinationsService()
                    return try service.saveDestination(destination)
                },
                saveCompletedSubject: DestinationStore.shared.refreshRecentDestinations
            )
        )
        show(viewController, sender: self)
    }
}

// MARK: - UISearchResultsUpdating

extension DestinationsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterDestinations(with: searchText)
    }
}
