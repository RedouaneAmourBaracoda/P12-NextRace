//
//  UserCalendar.swift
//  NextRace
//
//  Created by Redouane on 07/02/2025.
//

import EventKit
import Foundation

protocol CalendarService {
    func addEvent(calendarEvent: CalendarEvent) async throws -> Bool

    func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [CalendarEvent]
}

final class UserCalendar: CalendarService {
    let eventStore: EKEventStore

    static let shared = UserCalendar()

    init(eventStore: EKEventStore = EKEventStore()) {
        self.eventStore = eventStore
    }

    func addEvent(calendarEvent: CalendarEvent) async throws -> Bool {

        guard try await eventStore.requestFullAccessToEvents() else { return false }

        let ekEvent = EKEvent(eventStore: eventStore)

        ekEvent.title = calendarEvent.title

        ekEvent.location = calendarEvent.location

        ekEvent.startDate = calendarEvent.date

        ekEvent.endDate = calendarEvent.date.addingTimeInterval(3600 * 3)

        ekEvent.calendar = eventStore.defaultCalendarForNewEvents

        try eventStore.save(ekEvent, span: .thisEvent)

        return true
    }

    func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [CalendarEvent] {

        guard try await eventStore.requestFullAccessToEvents() else { return [] }

        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)

        return eventStore.events(matching: predicate).map { $0.toCalendarEvent }
    }
}

extension EKEvent {
    var toCalendarEvent: CalendarEvent {
        .init(
            title: title,
            location: location,
            date: startDate
        )
    }
}

struct CalendarEvent: Equatable {
    let title: String
    let location: String?
    let date: Date
}
