//
//  UserCalendarTests.swift
//  NextRaceTests
//
//  Created by Redouane on 07/02/2025.
//

@testable import NextRace
import EventKit
import XCTest

final class UserCalendarTests: XCTestCase {

    var userCalendar: UserCalendar!

    var store: EKEventStoreFake!

    override func setUpWithError() throws {
        store = EKEventStoreFake()
        userCalendar = UserCalendar(eventStore: store)
    }

    func testAddEventsWhenAccessRequestThrowsError() async throws {
        // Given.

        let randomError = RandomError()

        store.requestFullAccessToEventsError = randomError

        let event: CalendarEvent = .random()

        do {
            // When.
            _ = try await userCalendar.addEvent(calendarEvent: event)
        } catch let error as RandomError {
            // Then.
            XCTAssertEqual(error, randomError)
            XCTAssertTrue(store.savedEvents.isEmpty)
        }
    }

    func testAddEventsWhenAccessRequestIsDenied() async throws {
        // Given.

        store.accessIsGranted = false

        let event: CalendarEvent = .random()

        // When.

        let isEventAdded = try await userCalendar.addEvent(calendarEvent: event)

        // Then.
        XCTAssertFalse(isEventAdded)
        XCTAssertFalse(store.savedEvents.map({ $0.toCalendarEvent }).contains(event))
    }

    func testAddEventsWhenAccessRequestIsGrantedButSaveEventThrowsError() async throws {
        // Given.
        let randomError = RandomError()

        store.saveEventsError = randomError

        store.accessIsGranted = true

        let event: CalendarEvent = .random()

        do {
            // When.
            _ = try await userCalendar.addEvent(calendarEvent: event)
        } catch let error as RandomError {
            // Then.
            XCTAssertEqual(error, randomError)
            XCTAssertFalse(store.savedEvents.map({ $0.toCalendarEvent }).contains(event))
        }
    }

    func testAddEventsWhenAccessRequestIsGrantedAndSaveEventIsSuccess() async throws {
        // Given.

        let event: CalendarEvent = .random()

        store.accessIsGranted = true

        // When.

        let isEventAdded = try await userCalendar.addEvent(calendarEvent: event)

        // Then.
        XCTAssertTrue(isEventAdded)
        XCTAssertTrue(store.savedEvents.map({ $0.toCalendarEvent }).contains(event))
    }

    func testFetchEventsWhenAccessRequestThrowsError() async throws {
        // Given.

        let randomError = RandomError()
        store.requestFullAccessToEventsError = randomError

        do {
            // When.
            _ = try await userCalendar.fetchEvents(from: .random(), to: .random())
        } catch let error as RandomError {
            // Then.
            XCTAssertEqual(error, randomError)
            XCTAssertTrue(store.savedEvents.isEmpty)
        }
    }

    func testFetchEventsWhenAccessRequestIsDenied() async throws {
        // Given.

        let ekEvent: EKEvent = .random(eventStore: store)

        store.savedEvents.append(ekEvent)

        store.accessIsGranted = false

        // When.

        let events = try await userCalendar.fetchEvents(from: ekEvent.startDate, to: ekEvent.endDate)

        // Then.

        XCTAssertTrue(events.isEmpty)
    }

    func testFetchEventsWhenAccessRequestIsGranted() async throws {
        // Given.

        let ekEvent: EKEvent = .random(eventStore: store)

        store.savedEvents.append(ekEvent)

        store.accessIsGranted = true

        // When.

        let events = try await userCalendar.fetchEvents(from: ekEvent.startDate, to: ekEvent.endDate)

        // Then.

        XCTAssertTrue(events.contains(ekEvent.toCalendarEvent))
    }
}

extension EKEvent {
    static func random(eventStore: EKEventStore) -> EKEvent {
        let ekEvent = EKEvent(eventStore: eventStore)

        ekEvent.startDate = .random()

        ekEvent.endDate = ekEvent.startDate.addingTimeInterval(3600 * 3)

        ekEvent.title = .random()

        ekEvent.location = .random()

        ekEvent.calendar = eventStore.defaultCalendarForNewEvents

        return ekEvent
    }
}

extension CalendarEvent {
    static func random() -> CalendarEvent {
        .init(
            title: .random(),
            location: .random(),
            date: .random()
        )
    }
}

struct RandomError: LocalizedError, Equatable {
    var title: String?
    var errorDescription: String? { return description }
    var failureReason: String? { return description }

    private var description: String

    init(title: String? = nil, description: String = "") {
        self.title = title
        self.description = description
    }
}
