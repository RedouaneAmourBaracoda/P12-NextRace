//
//  SearchViewModelTests.swift
//  NextRaceTests
//
//  Created by Redouane on 02/02/2025.
//

@testable import NextRace
import XCTest

@MainActor
final class SearchViewModelTests: XCTestCase {

    var searchViewModel: SearchViewModel!

    var raceAPIService: MockRaceAPIService!

    var analyticsService: AnalyticsServiceMock!

    override func setUpWithError() throws {

        raceAPIService = MockRaceAPIService()

        analyticsService = AnalyticsServiceMock()

        searchViewModel = .init(raceAPIService: raceAPIService, analyticsService: analyticsService)
    }

    func testAnalytics() {
        // Given.

        let randomTitle: String = .random()

        let randomParameters: [String: String] = .random()

        analyticsService.logEventClosure = { title, parameters in
            XCTAssertEqual(title, randomTitle)
            guard let parameters else {
                XCTFail("Analytics parameters is nil.")
                return
            }
            guard let input = parameters as? [String: String] else {
                XCTFail("Analytics parameters could not be downcast.")
                return
            }
            XCTAssertEqual(input, randomParameters)
        }

        // When.

        searchViewModel.sendAnalytics(title: randomTitle, parameters: randomParameters)

        // Then.

        XCTAssertEqual(analyticsService.logEventCallsCounter, 1)
    }

    func testResetState() async {

        // Given.

        searchViewModel.searchResult = .random()

        searchViewModel.showRaces = true

        searchViewModel.searchInProgress = true

        // When.

        searchViewModel.resetState()

        // Then.

        XCTAssertNil(searchViewModel.searchResult)

        XCTAssertFalse(searchViewModel.showRaces)

        XCTAssertFalse(searchViewModel.searchInProgress)
    }

    func testGetRacesWhenTicketMasterAPIReturnsError() async {

        // Given.

        XCTAssertFalse(searchViewModel.searchInProgress)

        let error = TicketMasterAPIError.allCases.randomElement()

        raceAPIService.error = error

        // When.

        await searchViewModel.getRaces()

        // Then.

        XCTAssertEqual(raceAPIService.fetchRacesCallsCounter, 1)

        XCTAssertTrue(searchViewModel.shouldPresentAlert)

        XCTAssertEqual(searchViewModel.errorMessage, error?.userFriendlyDescription)

        XCTAssertNil(searchViewModel.searchResult)

        XCTAssertFalse(searchViewModel.searchInProgress)
    }

    func testGetRacesWhenAPIReturnsOtherError() async {

        // Given.

        XCTAssertFalse(searchViewModel.searchInProgress)

        let error = NSError()

        raceAPIService.error = error

        // When.

        await searchViewModel.getRaces()

        // Then.

        XCTAssertEqual(raceAPIService.fetchRacesCallsCounter, 1)

        XCTAssertTrue(searchViewModel.shouldPresentAlert)

        XCTAssertEqual(searchViewModel.errorMessage, Localizable.undeterminedErrorDescription)

        XCTAssertNil(searchViewModel.searchResult)

        XCTAssertFalse(searchViewModel.searchInProgress)
    }

    func testGetRacesIsSuccessWhenNoErrors() async {

        // Given.

        let expectedSearchResult: SearchResult = .random()

        raceAPIService.resultToReturn = expectedSearchResult

        // When.

        await searchViewModel.getRaces()

        // Then.

        XCTAssertEqual(raceAPIService.fetchRacesCallsCounter, 1)

        XCTAssertEqual(searchViewModel.searchResult, expectedSearchResult)

        XCTAssertTrue(searchViewModel.showRaces)

        XCTAssertFalse(searchViewModel.shouldPresentAlert)

        XCTAssertTrue(searchViewModel.errorMessage.isEmpty)

        XCTAssertFalse(searchViewModel.searchInProgress)
    }
}

extension SearchResult {
    static func random() -> SearchResult {
        .init(
            page: .random(),
            races: .random()
        )
    }
}

extension Page {
    static func random() -> Page {
        .init(
            size: .random(in: 0...10000),
            totalElements: .random(in: 0...10000),
            totalPages: .random(in: 0...1000),
            number: .random(in: 0...100)
        )
    }
}

extension Array<Race> {
    static func random(length: Int = .random(in: 0...10)) -> [Race] {
        [Int](repeating: 1, count: length).map { _ in Race.random() }
    }
}

extension Race {
    static func random() -> Race {
        .init(
            id: .random(),
            name: .random(),
            imageURL: .random(),
            venue: .init(
                name: .random(),
                postalCode: .random(),
                city: .random(),
                state: .random(),
                country: .random(),
                address: .random()
            ),
            date: .random(),
            seatmapURL: .random(),
            price: .init(
                currency: .random(),
                min: .random(in: 0...10000),
                max: .random(in: 0...10000)
            )
        )
    }
}

extension Date {
  static func random() -> Date {
    let randomTime = TimeInterval(Int32.random(in: 0...Int32.max))
    return Date(timeIntervalSince1970: randomTime)
  }
}

extension String {
    static func random(length: Int = .random(in: 0...100)) -> String {
        String((0..<length).map { _ in letters.randomElement() ?? " " })
    }

    private static let letters = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
}

extension [String: String] {
    static func random(length: Int = .random(in: 0...10)) -> [String: String] {
        var output: [String: String] = [:]
        [Int](repeating: 1, count: length).forEach { _ in
            output[.random()] = String.random()
        }

        return output
    }
}
