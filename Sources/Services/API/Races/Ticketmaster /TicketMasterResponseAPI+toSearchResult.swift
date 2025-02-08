//
//  TicketMasterResponseAPI+toSearchResult.swift
//  NextRace
//
//  Created by Redouane on 01/02/2025.
//

import Foundation

extension TicketMasterAPIResponse {
    var toSearchResult: SearchResult {
        .init(
            page: page,
            races: _embedded.events.map({ event in
                var venue: Race.Venue?
                if let safeVenue = event._embedded?.venues[0] {
                    venue = .init(
                        name: safeVenue.name,
                        postalCode: safeVenue.postalCode,
                        city: safeVenue.city?.name,
                        state: safeVenue.state?.name,
                        country: safeVenue.country?.name,
                        address: safeVenue.address?.line1
                    )
                }
                var date: Date?
                if let safeString = event.dates?.start.localDate {
                    date = DateFormatter.ticketMasterAPIDateFormatter.date(from: safeString)
                }
                return Race(
                    id: event.id,
                    name: event.name,
                    imageURL: event.images?[0].url,
                    venue: venue,
                    date: date,
                    seatmapURL: event.seatmap?.staticUrl,
                    price: event.priceRanges?.first
                )
            })
        )
    }
}

private extension DateFormatter {
    static let ticketMasterAPIDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
}
