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
                Race(
                    id: event.id,
                    name: event.name,
                    date: DateFormatter.ticketMasterAPIDateFormatter.date(from: event.dates.start.localDate),
                    imageURL: event.images.first?.url, 
                    seatmapURL: event.seatmap?.staticUrl,
                    price: event.priceRanges?.first,
                    venue: .init(
                        name: event._embedded.venues.first?.name ?? "",
                        postalCode: event._embedded.venues.first?.postalCode ?? "",
                        city: event._embedded.venues.first?.city.name ?? "" ,
                        state: event._embedded.venues.first?.state.name ?? "",
                        country: event._embedded.venues.first?.country.name ?? "",
                        address: event._embedded.venues.first?.address.line1 ?? ""
                    )
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
