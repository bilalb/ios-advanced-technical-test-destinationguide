//
//  DestinationDetails.swift
//  DestinationGuide
//
//  Created by Alexandre Guibert1 on 02/08/2021.
//

import Foundation

struct DestinationDetails : Hashable, Identifiable, Codable {
    let id: String
    let name: String
    let url: URL
}
