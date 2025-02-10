//
//  TicketMasterAPI.swift
//  NextRace
//
//  Created by Redouane on 01/02/2025.
//

import Foundation

protocol RaceAPIService {
    func fetchRaces(for championship: String, at page: Int) async throws -> SearchResult
}

struct TicketMasterAPIService: RaceAPIService {

    // MARK: - API infos.

    private enum APIInfos {

        static let ressource = "https://app.ticketmaster.com/discovery/v2/events?"

        static let apikey = "54lKbArhzWEf1ZTGlZfoUOaRYdF9MBT2"

        static let raceEventGenreId = "KnvZfZ7vA7k"

        static let locale = "*"

        static let sortDate = "date,asc"

        static let url = ressource
        + "apikey=" + apikey
        + "&locale=" + locale
        + "&genreId=" + raceEventGenreId
        + "&sort=" + sortDate
    }

    // MARK: - Properties.

    private var session: URLSession

    // MARK: - Dependency injection.

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Methods.

    func fetchRaces(for championship: String = "", at page: Int = Int()) async throws -> SearchResult {

        guard let url = URL(string: APIInfos.url + "&keyword=" + championship + "&page=" + String(page))
        else { throw TicketMasterAPIError.invalidURL }

        let request = URLRequest(url: url)

        let (data, response) = try await session.data(for: request)

        let result = TicketMasterAPIError.checkStatusCode(urlResponse: response)

        switch result {

        case .success:
            return try JSONDecoder().decode(TicketMasterAPIResponse.self, from: data).toSearchResult

        case let .failure(failure):

            throw failure
        }
    }
}
