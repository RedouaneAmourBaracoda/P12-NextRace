//
//  RaceItemDetailViewModel.swift
//  NextRace
//
//  Created by Redouane on 04/02/2025.
//

import EventKit
import SwiftUI

@MainActor
final class RaceItemDetailViewModel: ObservableObject {

    // MARK: - Properties

    @Published var race: Race

    // MARK: - Calendar

    @Published var scheduleInProgress: Bool = false

    @Published var isRaceScheduled: Bool = false

    @Published var showCalendarAlert: Bool = false

    @Published var calendarAlertTitle: String = ""

    @Published var calendarAlertMessage: String = ""

    let calendarService: CalendarService

    // MARK: - Initialization

    init(race: Race, calendarService: CalendarService = UserCalendar.shared) {
        self.race = race
        self.calendarService = calendarService
    }

    func addRaceToCalendar() async {
        guard let date = race.date else { return }

        scheduleInProgress = true

        do {
            let isEventAdded = try await calendarService.addEvent(
                calendarEvent: .init(
                    title: race.name,
                    location: race.venue?.name,
                    date: date
                )
            )
            if isEventAdded {
                isRaceScheduled = true
                calendarAlertTitle = Localizable.calendarSaveSuccessAlertTitle
                calendarAlertMessage = Localizable.calendarSaveSuccessAlertMessage
                showCalendarAlert = true
                scheduleInProgress = false
            } else {
                calendarAlertTitle = Localizable.calendarUpdateErrorAlertTitle
                calendarAlertMessage = Localizable.calendarSaveErrorAlertMessage
                showCalendarAlert = true
                scheduleInProgress = false
            }
        } catch {
            calendarAlertTitle = Localizable.calendarUpdateErrorAlertTitle
            calendarAlertMessage = Localizable.calendarSaveErrorAlertMessage
            showCalendarAlert = true
            scheduleInProgress = false
        }
    }

    func updateCalendarStatus() async {
        guard
            let date = race.date,
            let startDate = Calendar.current.date(byAdding: .day, value: -1, to: date),
            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
        else { return }

        do {
            let scheduledEvents = try await calendarService.fetchEvents(from: startDate, to: endDate)
            isRaceScheduled = scheduledEvents.contains(where: {
                $0.title == race.name
                && $0.date == date
                && $0.location == race.venue?.name
            })
        } catch {
            calendarAlertTitle = Localizable.calendarUpdateErrorAlertTitle
            calendarAlertMessage = Localizable.calendarUpdateErrorAlertMessage
            showCalendarAlert = true
        }
    }
}

private extension Localizable {
    static let calendarSaveSuccessAlertTitle = NSLocalizedString(
        "race-detail.calendar.save-succes-alert.title",
        comment: ""
    )
    static let calendarSaveSuccessAlertMessage = NSLocalizedString(
        "race-detail.calendar.save-success-alert.message",
        comment: ""
    )
    static let calendarUpdateErrorAlertTitle = NSLocalizedString(
        "race-detail.calendar.update-error-alert.title",
        comment: ""
    )
    static let calendarUpdateErrorAlertMessage = NSLocalizedString(
        "race-detail.calendar.update-error-alert.message",
        comment: ""
    )
    static let calendarSaveErrorAlertMessage = NSLocalizedString(
        "race-detail.calendar.save-error-alert.message",
        comment: ""
    )
}
