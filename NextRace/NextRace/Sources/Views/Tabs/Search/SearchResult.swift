//
//  SearchModel.swift
//  NextRace
//
//  Created by Redouane on 02/02/2025.
//

import Foundation

struct SearchResult {
    let page: Page
    let races: [Race]
}

struct Race: Codable {
    let id: String
    let name: String
    let date: Date?
    let imageURL: String?
    let seatmapURL: String?
    let price: PriceRanges?
    let venue: Venue

    struct Venue: Codable {
        let name: String
        let postalCode: String
        let city: String
        let state: String
        let country: String
        let address: String
    }
}

extension Race: Equatable {
    static func == (lhs: Race, rhs: Race) -> Bool {
        lhs.id == rhs.id
    }
}
