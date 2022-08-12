//
//  DestinationsViewController.swift
//  DestinationGuide
//
//  Created by Alexandre Guibert1 on 02/08/2021.
//

import UIKit

final class DestinationsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var array: [Destination]!
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 32, right: 0)
        layout.minimumLineSpacing = 32
        layout.itemSize = .init(width: 342, height: 280)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: self.collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DestinationCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.frame = view.frame
        collectionView.dataSource = self
        
        DestinationFetchingService().getDestinations { destinations in
            self.array = Array(try! destinations.get()).sorted(by: { $0.name < $1.name })
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if array != nil {
            return array.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let desti = array[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? DestinationCell {
            cell.setupCell(destination: desti)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
            headerView.titleLabel.text = "Toutes nos destinations"
            return headerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let desti = array[indexPath.item]
        
        DestinationFetchingService().getDestinationDetails(for: desti.id) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(details):
                    self.navigationController?.pushViewController(DestinationDetailsController(title: details.name, webviewUrl: details.url), animated: true)
                case let .failure(error):
                    let alert = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Annuler", style: .cancel))
                    
                    self.present(alert, animated: true)
                }
            }
            
        }
    }
}
