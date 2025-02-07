//
//  RaceItemDetailViewModelTests.swift
//  NextRaceTests
//
//  Created by Redouane on 06/02/2025.
//

@testable import NextRace
import XCTest

@MainActor
final class RaceItemDetailViewModelTests: XCTestCase {

    var raceItemDetailViewModel: RaceItemDetailViewModel!

    var coreDataService: CoreDataStackMock!

    override func setUpWithError() throws {

        coreDataService = CoreDataStackMock()

        raceItemDetailViewModel = .init(race: .random(), coreDataService: coreDataService)
    }

    func testAddToFavoritesFails() {
        // Given.

        // swiftlint:disable:next discouraged_direct_init
        let error = NSError()

        coreDataService.error = error

        // When.

        XCTAssertTrue(coreDataService.races.isEmpty)

        raceItemDetailViewModel.addToFavorites()

        // Then.

        XCTAssertTrue(coreDataService.races.isEmpty)

        XCTAssertEqual(1, coreDataService.addRaceCallsCounter)

        XCTAssertTrue(raceItemDetailViewModel.shouldPresentAlert)

        XCTAssertEqual(raceItemDetailViewModel.alertTitle, Localizable.errorAlertTitle)

        XCTAssertEqual(raceItemDetailViewModel.alertMessage, Localizable.persistenceErrorDescription)
    }

    func testAddToFavoritesSuccess() {
        // Given.

        let race: Race = .random()

        raceItemDetailViewModel.race = race

        // When.

        XCTAssertTrue(coreDataService.races.isEmpty)

        raceItemDetailViewModel.addToFavorites()

        // Then.

        XCTAssertTrue(coreDataService.races.contains(race))

        XCTAssertEqual(1, coreDataService.addRaceCallsCounter)

        XCTAssertFalse(raceItemDetailViewModel.shouldPresentAlert)

        XCTAssertTrue(raceItemDetailViewModel.alertTitle.isEmpty)

        XCTAssertTrue(raceItemDetailViewModel.alertMessage.isEmpty)
    }

    func testRefreshFavoriteStateFails() {
        // Given.

        // swiftlint:disable:next discouraged_direct_init
        let error = NSError()

        coreDataService.error = error

        // When.

        raceItemDetailViewModel.refreshFavoriteState()

        // Then.

        XCTAssertEqual(1, coreDataService.fetchRaceCallsCounter)

        XCTAssertTrue(raceItemDetailViewModel.shouldPresentAlert)

        XCTAssertEqual(raceItemDetailViewModel.alertTitle, Localizable.errorAlertTitle)

        XCTAssertEqual(raceItemDetailViewModel.alertMessage, Localizable.persistenceErrorDescription)

        XCTAssertTrue(coreDataService.races.isEmpty)

        XCTAssertFalse(raceItemDetailViewModel.isFavorite)
    }

    func testRefreshFavoriteStateSuccess() throws {
        // Given.

        let race: Race = .random()

        raceItemDetailViewModel.race = race

        try coreDataService.add(newRace: race)

        // When.

        XCTAssertFalse(raceItemDetailViewModel.isFavorite)

        raceItemDetailViewModel.refreshFavoriteState()

        // Then.

        XCTAssertTrue(raceItemDetailViewModel.isFavorite)

        XCTAssertEqual(1, coreDataService.fetchRaceCallsCounter)

        XCTAssertFalse(raceItemDetailViewModel.shouldPresentAlert)

        XCTAssertTrue(raceItemDetailViewModel.alertTitle.isEmpty)

        XCTAssertTrue(raceItemDetailViewModel.alertMessage.isEmpty)
    }

    func testRemoveFromFavoritesFails() {
        // Given.

        // swiftlint:disable:next discouraged_direct_init
        let error = NSError()

        coreDataService.error = error

        // When.

        raceItemDetailViewModel.removeFromFavorites()

        // Then.

        XCTAssertEqual(1, coreDataService.removeRaceCallsCounter)

        XCTAssertTrue(raceItemDetailViewModel.shouldPresentAlert)

        XCTAssertEqual(raceItemDetailViewModel.alertTitle, Localizable.errorAlertTitle)

        XCTAssertEqual(raceItemDetailViewModel.alertMessage, Localizable.persistenceErrorDescription)
    }

    func testRemoveFromFavoritesSuccess() {
        // Given.

        let race: Race = .random()

        raceItemDetailViewModel.race = race

        raceItemDetailViewModel.addToFavorites()

        raceItemDetailViewModel.refreshFavoriteState()

        XCTAssertTrue(raceItemDetailViewModel.isFavorite)

        // When.

        raceItemDetailViewModel.removeFromFavorites()

        raceItemDetailViewModel.refreshFavoriteState()

        // Then.

        XCTAssertFalse(raceItemDetailViewModel.isFavorite)

        XCTAssertFalse(coreDataService.races.contains(race))

        XCTAssertEqual(1, coreDataService.removeRaceCallsCounter)

        XCTAssertFalse(raceItemDetailViewModel.shouldPresentAlert)

        XCTAssertTrue(raceItemDetailViewModel.alertTitle.isEmpty)

        XCTAssertTrue(raceItemDetailViewModel.alertMessage.isEmpty)
    }
}
