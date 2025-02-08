//
//  CalendarServiceMock.swift
//  NextRace
//
//  Created by Redouane on 07/02/2025.
//

import EventKit
import Foundation

final class CalendarServiceMock: CalendarService {
    var fetchedEventsToReturn: [CalendarEvent] = []

    var booleanToReturn: Bool = false

    var error: Error?

    var addEventCallsCounter = 0

    var fetchEventsCallsCounter = 0

    func addEvent(calendarEvent: CalendarEvent) async throws -> Bool {
        addEventCallsCounter += 1

        guard let error else { return booleanToReturn }

        throw error
    }

    func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [CalendarEvent] {
        fetchEventsCallsCounter += 1

        guard let error else { return fetchedEventsToReturn }

        throw error
    }
}
