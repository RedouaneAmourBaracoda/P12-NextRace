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

    init(coreDataService: CoreDataService = CoreDataStack.shared, analyticsService: AnalyticsService = .shared) {
        self.coreDataService = coreDataService
        self.analyticsService = analyticsService
    }

    // MARK: - Methods

    func refreshRaces() {
        do {
            favoriteRaces = try coreDataService.fetch()
        } catch {
            errorMessage = Localizable.persistenceErrorDescription
            shouldPresentAlert = true
        }
    }

    func sendScreenEventAnalytics() {
        analyticsService.logEvent(
            title: AnalyticsEventScreenView,
            parameters: ["Favorite_Races_Total": favoriteRaces.count]
        )
    }
}
