//
//  CoreDataStackMock.swift
//  NextRaceTests
//
//  Created by Redouane on 06/02/2025.
//

@testable import NextRace
import Foundation

final class CoreDataStackMock: CoreDataService {

    var races: [Race] = []

    var error: Error?

    var addRaceCallsCounter = 0

    var removeRaceCallsCounter = 0

    var fetchRaceCallsCounter = 0

    func add(newRace: Race) throws {
        addRaceCallsCounter += 1

        guard let error else {
            races.append(newRace)
            return
        }

        throw error
    }

    func remove(race: Race) throws {
        removeRaceCallsCounter += 1

        guard let error else {
            races.removeAll { $0 == race }
            return
        }

        throw error
    }

    func fetch() throws -> [Race] {
        fetchRaceCallsCounter += 1

        guard let error else { return races }

        throw error
    }
}
