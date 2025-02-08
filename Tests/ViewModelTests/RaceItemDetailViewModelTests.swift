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

    var calendarService: CalendarServiceMock!

    override func setUpWithError() throws {

        coreDataService = CoreDataStackMock()

        calendarService = CalendarServiceMock()

        raceItemDetailViewModel = .init(
            race: .random(),
            calendarService: calendarService,
            coreDataService: coreDataService
        )
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

    func testAddEventToCalendarWhenThrowsError() async {
        // Given.

        calendarService.error = RandomError()

        XCTAssertFalse(raceItemDetailViewModel.isRaceScheduled)

        // When.

        await raceItemDetailViewModel.addRaceToCalendar()

        // Then.

        XCTAssertEqual(1, calendarService.addEventCallsCounter)

        XCTAssertFalse(raceItemDetailViewModel.isRaceScheduled)

        XCTAssertEqual(raceItemDetailViewModel.alertTitle, Localizable.calendarUpdateErrorAlertTitle)

        XCTAssertEqual(raceItemDetailViewModel.alertMessage, Localizable.calendarSaveErrorAlertMessage)

        XCTAssertTrue(raceItemDetailViewModel.shouldPresentAlert)

        XCTAssertFalse(raceItemDetailViewModel.scheduleInProgress)
    }

    func testAddEventToCalendarWhenRequestAccessIsDenied() async {
        // Given.

        calendarService.booleanToReturn = false

        // When.

        await raceItemDetailViewModel.addRaceToCalendar()

        // Then.

        XCTAssertEqual(1, calendarService.addEventCallsCounter)

        XCTAssertFalse(raceItemDetailViewModel.isRaceScheduled)

        XCTAssertEqual(raceItemDetailViewModel.alertTitle, Localizable.calendarUpdateErrorAlertTitle)

        XCTAssertEqual(raceItemDetailViewModel.alertMessage, Localizable.calendarSaveErrorAlertMessage)

        XCTAssertTrue(raceItemDetailViewModel.shouldPresentAlert)

        XCTAssertFalse(raceItemDetailViewModel.scheduleInProgress)
    }

    func testAddEventToCalendarWhenRequestAccessIsGranted() async {
        // Given.

        calendarService.booleanToReturn = true

        // When.

        await raceItemDetailViewModel.addRaceToCalendar()

        // Then.

        XCTAssertEqual(1, calendarService.addEventCallsCounter)

        XCTAssertTrue(raceItemDetailViewModel.isRaceScheduled)

        XCTAssertEqual(raceItemDetailViewModel.alertTitle, Localizable.calendarSaveSuccessAlertTitle)

        XCTAssertEqual(raceItemDetailViewModel.alertMessage, Localizable.calendarSaveSuccessAlertMessage)

        XCTAssertTrue(raceItemDetailViewModel.shouldPresentAlert)

        XCTAssertFalse(raceItemDetailViewModel.scheduleInProgress)
    }

    func testUpdateCalendarStatusWhenRequestAccessThrowsError() async {
        // Given.

        calendarService.error = RandomError()

        // When.

        await raceItemDetailViewModel.updateCalendarStatus()

        // Then.

        XCTAssertEqual(1, calendarService.fetchEventsCallsCounter)

        XCTAssertFalse(raceItemDetailViewModel.isRaceScheduled)

        XCTAssertEqual(raceItemDetailViewModel.alertTitle, Localizable.calendarUpdateErrorAlertTitle)

        XCTAssertEqual(raceItemDetailViewModel.alertMessage, Localizable.calendarUpdateErrorAlertMessage)

        XCTAssertTrue(raceItemDetailViewModel.shouldPresentAlert)

        XCTAssertFalse(raceItemDetailViewModel.scheduleInProgress)
    }

    func testUpdateCalendarStatusWhenRequestAccessIsDenied() async {
        // Given.

        calendarService.fetchedEventsToReturn = []

        // When.

        await raceItemDetailViewModel.updateCalendarStatus()

        // Then.

        XCTAssertEqual(1, calendarService.fetchEventsCallsCounter)

        XCTAssertFalse(raceItemDetailViewModel.isRaceScheduled)

        XCTAssertTrue(raceItemDetailViewModel.alertTitle.isEmpty)

        XCTAssertTrue(raceItemDetailViewModel.alertMessage.isEmpty)

        XCTAssertFalse(raceItemDetailViewModel.shouldPresentAlert)

        XCTAssertFalse(raceItemDetailViewModel.scheduleInProgress)
    }

    func testUpdateCalendarStatusWhenRequestAccessIsGranted() async {
        // Given.

        let title: String = .random()

        let location: String = .random()

        let date: Date = .random()

        raceItemDetailViewModel.race = .init(
            id: .random(),
            name: title,
            imageURL: .random(),
            venue: .init(
                name: location,
                postalCode: .random(),
                city: .random(),
                state: .random(),
                country: .random(),
                address: .random()),
            date: date,
            seatmapURL: .random(),
            price: nil
        )

        let event: CalendarEvent = .init(title: title, location: location, date: date)

        calendarService.fetchedEventsToReturn = [event]

        // When.

        await raceItemDetailViewModel.updateCalendarStatus()

        // Then.

        XCTAssertEqual(1, calendarService.fetchEventsCallsCounter)

        XCTAssertTrue(raceItemDetailViewModel.isRaceScheduled)

        XCTAssertTrue(raceItemDetailViewModel.alertTitle.isEmpty)

        XCTAssertTrue(raceItemDetailViewModel.alertMessage.isEmpty)

        XCTAssertFalse(raceItemDetailViewModel.shouldPresentAlert)

        XCTAssertFalse(raceItemDetailViewModel.scheduleInProgress)
    }
}
