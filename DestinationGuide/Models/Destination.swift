//
//  Destination.swift
//  DestinationGuide
//
//  Created by Alexandre Guibert1 on 02/08/2021.
//

import Foundation

struct Destination : Hashable, Identifiable {
    let id: String
    let name: String
    let picture: URL
    let tag: String?
    let rating: Int
}

extension Destination: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.name < rhs.name
    }
}
