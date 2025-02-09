//
//  FavoriteRacesListViewModel.swift
//  NextRace
//
//  Created by Redouane on 06/02/2025.
//

import Firebase
import SwiftUI

final class FavoriteRacesListViewModel: ObservableObject {

    // MARK: - Properties

    @Published var favoriteRaces: [Race] = []

    @Published var shouldPresentAlert = false

    var errorMessage: String = ""

    // MARK: - Services

    private let coreDataService: CoreDataService

    private let analyticsService: AnalyticsService

    // MARK: - Initialization

    init(
        coreDataService: CoreDataService = CoreDataStack.shared,
        analyticsService: AnalyticsService = GoogleFirebaseAnalyticsService()
    ) {
        self.coreDataService = coreDataService
        self.analyticsService = analyticsService
    }

    // MARK: - Methods

    func refreshRaces() {
        sendAnalytics(title: AnalyticsEventScreenView, parameters: ["Favorite_Races_Total": favoriteRaces.count])
        do {
            favoriteRaces = try coreDataService.fetch()
        } catch {
            errorMessage = Localizable.persistenceErrorDescription
            shouldPresentAlert = true
        }
    }

    func sendAnalytics(title: String, parameters: [String: Any]?) {
        analyticsService.logEvent(title: title, parameters: parameters)
    }
}
