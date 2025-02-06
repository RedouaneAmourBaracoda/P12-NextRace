//
//  RaceListViewModelTests.swift
//  NextRaceTests
//
//  Created by Redouane on 05/02/2025.
//

@testable import NextRace
import XCTest

@MainActor
final class RaceListViewModelTests: XCTestCase {

    var raceListViewModel: RaceListViewModel!

    var raceAPIService: MockRaceAPIService!

    override func setUpWithError() throws {

        raceAPIService = MockRaceAPIService()

        raceListViewModel = .init(selectedChampionship: .allCases.randomElement() ?? .nascar, searchResult: .init(page: .random(), races: .random()), raceAPIService: raceAPIService)
    }

    func testLoadMoreWhenTicketMasterAPIReturnsError() async {

        // Given.

        let error = TicketMasterAPIError.allCases.randomElement()

        raceAPIService.error = error

        // When.

        await raceListViewModel.loadmore()

        // Then.

        XCTAssertEqual(raceAPIService.fetchRacesCallsCounter, 1)

        XCTAssertTrue(raceListViewModel.shouldPresentAlert)

        XCTAssertEqual(raceListViewModel.errorMessage, error?.userFriendlyDescription)

    }

    func testGetRacesWhenAPIReturnsOtherError() async {

        // Given.

        // swiftlint:disable:next discouraged_direct_init
        let error = NSError()

        raceAPIService.error = error

        // When.

        await raceListViewModel.loadmore()

        // Then.

        XCTAssertEqual(raceAPIService.fetchRacesCallsCounter, 1)

        XCTAssertTrue(raceListViewModel.shouldPresentAlert)

        XCTAssertEqual(raceListViewModel.errorMessage, Localizable.undeterminedErrorDescription)
    }

    func testLoadMoreWhenOnlyOnePage() async {

        // Given.

        raceListViewModel.currentPage = 0

        raceListViewModel.totalPages = 1

        // Then.

        XCTAssertFalse(raceListViewModel.showLoadMore)

    }

    func testLoadMoreWhenMoreThanOnePage() async {

        // Given.

        raceListViewModel.currentPage = 0

        raceListViewModel.totalPages = 2

        let racesBeforeLoadingMore = raceListViewModel.races

        let newResultToReturn = SearchResult(
            page: .init(
                size: .random(in: 1...10000),
                totalElements: .random(in: 1...10000),
                totalPages: 2,
                number: 1
            ),
            races: .random()
        )

        raceAPIService.resultToReturn = newResultToReturn

        XCTAssertTrue(raceListViewModel.showLoadMore)

        XCTAssertFalse(raceListViewModel.searchInProgress)

        // When.

        await raceListViewModel.loadmore()

        // Then.

        XCTAssertEqual(raceAPIService.fetchRacesCallsCounter, 1)

        XCTAssertEqual(raceListViewModel.currentPage, 1)

        XCTAssertEqual(raceListViewModel.totalPages, 2)

        XCTAssertEqual(raceListViewModel.races, racesBeforeLoadingMore + newResultToReturn.races)

        XCTAssertEqual(raceListViewModel.races.count, racesBeforeLoadingMore.count + newResultToReturn.races.count)

        XCTAssertFalse(raceListViewModel.showLoadMore)

        XCTAssertFalse(raceListViewModel.searchInProgress)

        XCTAssertFalse(raceListViewModel.shouldPresentAlert)

        XCTAssertTrue(raceListViewModel.errorMessage.isEmpty)
    }
}
