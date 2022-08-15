//
//  DestinationCell.ViewModel.swift
//  DestinationGuide
//
//  Created by Bilal on 13/08/2022.
//

import Foundation

extension DestinationCell {
    struct ViewModel {
        let name: String
        let rating: Int
        let tag: String?
        let imageURL: URL
        let id: Destination.ID
    }
}

extension DestinationCell.ViewModel {
    init(destination: Destination) {
        name = destination.name
        rating = destination.rating
        tag = destination.tag
        imageURL = destination.picture
        id = destination.id
    }
}
