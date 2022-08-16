//
//  DestinationListViewController.ViewModel.SectionModel.swift
//  DestinationGuide
//
//  Created by Bilal on 14/08/2022.
//

import Foundation

extension DestinationListViewController.ViewModel {
    struct SectionModel {
        let title: String
        let cellModels: [DestinationCellModel]
    }
}

extension DestinationListViewController.ViewModel.SectionModel: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title && lhs.cellModels.map(\.id) == rhs.cellModels.map(\.id)
    }
}

protocol DestinationCellModel {
    var id: Destination.ID { get }
}

extension RecentDestinationCell.ViewModel: DestinationCellModel {}

extension DestinationCell.ViewModel: DestinationCellModel {}

extension NoSearchResultCell.ViewModel: DestinationCellModel {
    var id: Destination.ID {
        "NoSearchResultCell"
    }
}
