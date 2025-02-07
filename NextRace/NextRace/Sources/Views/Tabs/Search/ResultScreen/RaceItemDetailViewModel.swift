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

    @Published var showCalendarAlert: Bool = false

    @Published var calendarAlertTitle: String = ""

    @Published var calendarAlertMessage: String = ""

    // MARK: - Initialization

    init(race: Race) {
        self.race = race
    }

    func addRaceToCalendar() {
        guard let saveDate = race.date else { return }

        let eventStore = EKEventStore()

        let eventName = race.name

        let eventLocation = race.venue?.name ?? ""

        eventStore.requestWriteOnlyAccessToEvents() { [weak self] (granted, error) in
            if granted && error == nil {
                let calendarEvent = EKEvent(eventStore: eventStore)
                calendarEvent.title = eventName
                calendarEvent.location = eventLocation
                calendarEvent.startDate = saveDate
                calendarEvent.endDate = saveDate.addingTimeInterval(3600 * 3)
                calendarEvent.calendar = eventStore.defaultCalendarForNewEvents

                do {
                    try eventStore.save(calendarEvent, span: .thisEvent)
                    DispatchQueue.main.async {
                        self?.calendarAlertTitle = Localizable.raceDetailScreenCalendarAlertTitle
                        self?.calendarAlertMessage = Localizable.raceDetailScreenCalendarAlertMessage
                        self?.showCalendarAlert = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.calendarAlertTitle = Localizable.raceDetailScreenCalendarErrorAlertTitle
                        self?.calendarAlertMessage = Localizable.raceDetailScreenCalendarErrorAlertMessage
                        self?.showCalendarAlert = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.calendarAlertTitle = Localizable.raceDetailScreenCalendarErrorAlertTitle
                    self?.calendarAlertMessage = Localizable.raceDetailScreenCalendarAccessDeniedAlertMessage
                    self?.showCalendarAlert = true
                }
            }
        }
    }
}

private extension Localizable {
    static let raceDetailScreenCalendarAlertTitle = NSLocalizedString(
        "race-detail.calendar-alert.title",
        comment: ""
    )
    static let raceDetailScreenCalendarAlertMessage = NSLocalizedString(
        "race-detail.calendar-alert.message",
        comment: ""
    )
    static let raceDetailScreenCalendarErrorAlertTitle = NSLocalizedString(
        "race-detail.calendar-error-alert.title",
        comment: ""
    )
    static let raceDetailScreenCalendarErrorAlertMessage = NSLocalizedString(
        "race-detail.calendar-error-alert.message",
        comment: ""
    )
    static let raceDetailScreenCalendarAccessDeniedAlertMessage = NSLocalizedString(
        "race-detail.calendar-access-denied-alert.message",
        comment: ""
    )
}
