//
//  RecentDestinationCell.ViewModel.swift
//  DestinationGuide
//
//  Created by Bilal on 13/08/2022.
//

import Foundation

extension RecentDestinationCell {
    struct ViewModel {
        let name: String
        let id: Destination.ID
    }
}

extension RecentDestinationCell.ViewModel {
    init(destinationDetails: DestinationDetails) {
        name = destinationDetails.name
        id = destinationDetails.id
    }
}
