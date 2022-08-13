//
//  DestinationsViewController.ViewModel.SectionModel.swift
//  DestinationGuide
//
//  Created by Bilal on 14/08/2022.
//

import Foundation

extension DestinationsViewController.ViewModel {
    struct SectionModel {
        let title: String
        let cellModels: [DestinationCellModel]
    }
}

protocol DestinationCellModel {
    var id: Destination.ID { get }
}

extension RecentDestinationCell.ViewModel: DestinationCellModel {}

extension DestinationCell.ViewModel: DestinationCellModel {}
