//
//  MockRaceAPIService.swift
//  NextRaceTests
//
//  Created by Redouane on 02/02/2025.
//


@testable import NextRace
import Foundation

final class MockRaceAPIService: RaceAPIService {

    var resultToReturn: SearchResult!

    var error: Error?

    var fetchRacesCallsCounter = 0

    func fetchRaces(for championship: String) async throws -> SearchResult {
        fetchRacesCallsCounter += 1

        guard let error else { return resultToReturn }

        throw error
    }
}
