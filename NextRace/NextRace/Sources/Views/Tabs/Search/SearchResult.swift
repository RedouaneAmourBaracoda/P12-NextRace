//
//  SearchModel.swift
//  NextRace
//
//  Created by Redouane on 02/02/2025.
//

import Foundation

struct SearchResult: Equatable {
    let page: Page
    let races: [Race]
}

struct Race: Equatable {
    let id: String
    let name: String
    let imageURL: String
    let venue: Venue
    let date: Date?
    let seatmapURL: String?
    let price: PriceRanges?

    struct Venue: Equatable {
        let name: String
        let postalCode: String
        let city: String
        let state: String
        let country: String
        let address: String
    }
}
