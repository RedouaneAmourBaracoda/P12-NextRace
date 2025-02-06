//
//  FavoriteRaceListViewModelTests.swift
//  NextRaceTests
//
//  Created by Redouane on 06/02/2025.
//

@testable import NextRace
import XCTest

@MainActor
final class FavoriteRacesListViewModelTests: XCTestCase {

    var favoriteRacesListViewModel: FavoriteRacesListViewModel!

    var coreDataService: CoreDataStackMock!

    override func setUpWithError() throws {

        coreDataService = CoreDataStackMock()

        favoriteRacesListViewModel = .init(coreDataService: coreDataService)
    }

    func testRefreshFavoriteStateFails() {
        // Given.

        // swiftlint:disable:next discouraged_direct_init
        let error = NSError()

        coreDataService.error = error

        // When.

        favoriteRacesListViewModel.refreshRaces()

        // Then.

        XCTAssertEqual(1, coreDataService.fetchRaceCallsCounter)

        XCTAssertTrue(favoriteRacesListViewModel.shouldPresentAlert)

        XCTAssertEqual(favoriteRacesListViewModel.errorMessage, Localizable.persistenceErrorDescription)
    }

    func testRefreshFavoriteStateSuccessWhenAddingNewRecipe() throws {
        // Given.

        let race: Race = .random()

        try coreDataService.add(newRace: race)

        // When.

        XCTAssertTrue(favoriteRacesListViewModel.favoriteRaces.isEmpty)

        favoriteRacesListViewModel.refreshRaces()

        // Then.

        XCTAssertTrue(favoriteRacesListViewModel.favoriteRaces.contains(race))

        XCTAssertEqual(1, coreDataService.fetchRaceCallsCounter)

        XCTAssertFalse(favoriteRacesListViewModel.shouldPresentAlert)

        XCTAssertTrue(favoriteRacesListViewModel.errorMessage.isEmpty)
    }

    func testRefreshFavoriteStateSuccessWhenRemovingRecipe() throws {
        // Given.

        let race: Race = .random()

        try coreDataService.add(newRace: race)

        favoriteRacesListViewModel.refreshRaces()

        XCTAssertTrue(favoriteRacesListViewModel.favoriteRaces.contains(race))

        // When.

        try coreDataService.remove(race: race)

        favoriteRacesListViewModel.refreshRaces()

        // Then.

        XCTAssertTrue(favoriteRacesListViewModel.favoriteRaces.isEmpty)

        XCTAssertFalse(coreDataService.races.contains(race))

        XCTAssertEqual(1, coreDataService.removeRaceCallsCounter)

        XCTAssertFalse(favoriteRacesListViewModel.shouldPresentAlert)

        XCTAssertTrue(favoriteRacesListViewModel.errorMessage.isEmpty)
    }
}
