//
//  FavoriteRacesListViewModel.swift
//  NextRace
//
//  Created by Redouane on 06/02/2025.
//

import SwiftUI

final class FavoriteRacesListViewModel: ObservableObject {

    // MARK: - Properties

    @Published var favoriteRaces: [Race] = []

    @Published var shouldPresentAlert = false

    var errorMessage: String = ""

    // MARK: - Services

    private let coreDataService: CoreDataService

    // MARK: - Initialization

    init(coreDataService: CoreDataService = CoreDataStack.shared) {
        self.coreDataService = coreDataService
    }

    // MARK: - Methods

    func refreshRaces() {
        do {
            favoriteRaces = try coreDataService.fetch()
        } catch {
            errorMessage = Localizable.undeterminedErrorDescription
            shouldPresentAlert = true
        }
    }
}
