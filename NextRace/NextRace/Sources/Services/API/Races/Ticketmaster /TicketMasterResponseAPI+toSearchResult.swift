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
                let venue = event._embedded.venues[0]
                return Race(
                    id: event.id,
                    name: event.name,
                    imageURL: event.images[0].url,
                    venue: .init(
                        name: venue.name,
                        postalCode: venue.postalCode,
                        city: venue.city.name,
                        state: venue.state.name,
                        country: venue.country.name,
                        address: venue.address.line1
                    ),
                    date: DateFormatter.ticketMasterAPIDateFormatter.date(from: event.dates.start.localDate),
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
