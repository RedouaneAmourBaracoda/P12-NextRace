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

    @Published var isFavorite: Bool = false

    @Published var scheduleInProgress: Bool = false

    @Published var isRaceScheduled: Bool = false

    @Published var shouldPresentAlert = false

    @Published var alertTitle: String = ""

    @Published var alertMessage: String = ""

    // MARK: - Services

    private let coreDataService: CoreDataService

    private let calendarService: CalendarService

    private let analyticsService: AnalyticsService

    // MARK: - Initialization

    init(
        race: Race,
        calendarService: CalendarService = UserCalendar.shared,
        coreDataService: CoreDataService = CoreDataStack.shared,
        analyticsService: AnalyticsService = GoogleFirebaseAnalyticsService()
    ) {
        self.race = race
        self.calendarService = calendarService
        self.coreDataService = coreDataService
        self.analyticsService = analyticsService
    }

    // MARK: - Methods

    func addToFavorites() {
        do {
            try coreDataService.add(newRace: race)
            isFavorite = true
        } catch {
            presentError()
        }
    }

    func removeFromFavorites() {
        do {
            try coreDataService.remove(race: race)
            isFavorite = false
        } catch {
            presentError()
        }
    }

    func refreshFavoriteState() {
        do {
            let favoriteRaces = try coreDataService.fetch()
            isFavorite = favoriteRaces.contains(race)
        } catch {
            presentError()
        }
    }

    private func presentError() {
        alertTitle = Localizable.errorAlertTitle
        alertMessage = Localizable.persistenceErrorDescription
        shouldPresentAlert = true
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
                alertTitle = Localizable.calendarSaveSuccessAlertTitle
                alertMessage = Localizable.calendarSaveSuccessAlertMessage
                shouldPresentAlert = true
                scheduleInProgress = false
                sendAnalytics(title: "press_agenda", parameters: [race.name: race.date ?? ""])
            } else {
                alertTitle = Localizable.calendarUpdateErrorAlertTitle
                alertMessage = Localizable.calendarSaveErrorAlertMessage
                shouldPresentAlert = true
                scheduleInProgress = false
            }
        } catch {
            alertTitle = Localizable.calendarUpdateErrorAlertTitle
            alertMessage = Localizable.calendarSaveErrorAlertMessage
            shouldPresentAlert = true
            scheduleInProgress = false
        }
    }

    func updateCalendarStatus() async {
        guard
            let date = race.date,
            let startDate = Calendar.current.date(byAdding: .day, value: -1, to: date),
            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
        else { return }

        scheduleInProgress = true

        do {
            let scheduledEvents = try await calendarService.fetchEvents(from: startDate, to: endDate)
            isRaceScheduled = scheduledEvents.contains(where: {
                $0.title == race.name
                && $0.date == date
                && $0.location == race.venue?.name
            })
            scheduleInProgress = false
        } catch {
            alertTitle = Localizable.calendarUpdateErrorAlertTitle
            alertMessage = Localizable.calendarUpdateErrorAlertMessage
            scheduleInProgress = false
            shouldPresentAlert = true
        }
    }

    func sendAnalytics(title: String, parameters: [String: Any]?) {
        analyticsService.logEvent(title: title, parameters: parameters)
    }
}

extension Localizable {
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
