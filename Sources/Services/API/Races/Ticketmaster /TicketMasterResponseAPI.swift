//
//  TicketMasterResponseAPI.swift
//  NextRace
//
//  Created by Redouane on 01/02/2025.
//

import Foundation

struct TicketMasterAPIResponse: Codable, Equatable {
    let _embedded: EmbeddedEvents
    let page: Page
}

struct EmbeddedEvents: Codable, Equatable {
    let events: [Event]
}

struct Event: Codable, Equatable {
    let name: String
    let id: String
    let images: [ImageContainer]?
    let dates: DateContainer?
    let priceRanges: [PriceRanges]?
    let seatmap: SeatMap?
    let _embedded: EmbeddedVenues?
}

struct PriceRanges: Codable, Equatable {
    let currency: String
    let min: Float
    let max: Float
}

struct SeatMap: Codable, Equatable {
    let staticUrl: String
}

struct EmbeddedVenues: Codable, Equatable {
    let venues: [Venue]
}

struct Venue: Codable, Equatable {
    let name: String
    let id: String
    let postalCode: String?
    let city: VenueCity?
    let state: VenueState?
    let country: VenueCountry?
    let address: VenueAddress?
}

struct VenueCity: Codable, Equatable {
    let name: String
}

struct VenueState: Codable, Equatable {
    let name: String
    let stateCode: String
}

struct VenueCountry: Codable, Equatable {
    let name: String
    let countryCode: String
}

struct VenueAddress: Codable, Equatable {
    let line1: String
}

struct ImageContainer: Codable, Equatable {
    let url: String
}

struct DateContainer: Codable, Equatable {
    let start: StartDateContainer
}

struct StartDateContainer: Codable, Equatable {
    let localDate: String
}

struct Page: Codable, Equatable {
    let size: Int
    let totalElements: Int
    let totalPages: Int
    let number: Int
}

