//
//  CalendarService.swift
//  NextRace
//
//  Created by Redouane on 07/02/2025.
//

import EventKit
import Foundation

protocol CalendarService {
    func addEvent(calendarEvent: CalendarEvent) async throws

    func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [CalendarEvent]
}

struct UserCalendar: CalendarService {
    func addEvent(calendarEvent: CalendarEvent) async throws {
        let eventStore = EKEventStore()

        try await eventStore.requestFullAccessToEvents()

        let ekEvent = EKEvent(eventStore: eventStore)

        ekEvent.title = calendarEvent.title

        ekEvent.location = calendarEvent.location

        ekEvent.startDate = calendarEvent.date

        ekEvent.endDate = calendarEvent.date.addingTimeInterval(3600 * 3)

        ekEvent.calendar = eventStore.defaultCalendarForNewEvents

        try eventStore.save(ekEvent, span: .thisEvent)
    }

    func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [CalendarEvent] {
        let eventStore = EKEventStore()

        try await eventStore.requestFullAccessToEvents()

        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)

        return eventStore.events(matching: predicate).map { $0.toCalendarEvent }
    }
}

private extension EKEvent {
    var toCalendarEvent: CalendarEvent {
        .init(
            title: title,
            location: location,
            date: startDate
        )
    }
}

struct CalendarEvent {
    let title: String
    let location: String?
    let date: Date
}
