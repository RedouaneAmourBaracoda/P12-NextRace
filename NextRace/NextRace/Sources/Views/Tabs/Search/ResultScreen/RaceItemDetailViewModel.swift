//
//  RaceItemDetailViewModel.swift
//  NextRace
//
//  Created by Redouane on 04/02/2025.
//

import SwiftUI

final class RaceItemDetailViewModel: ObservableObject {

    // MARK: - Properties

    @Published var race: Race

    @Published var isFavorite: Bool = false

    @Published var shouldPresentAlert = false

    var errorMessage: String = ""

    // MARK: - Services

    private let coreDataService: CoreDataService

    // MARK: - Initialization

    init(race: Race, coreDataService: CoreDataService = CoreDataStack.shared) {
        self.race = race
        self.coreDataService = coreDataService
    }

    // MARK: - Methods

    func addToFavorites() {
        do {
            try coreDataService.add(newRace: race)
            isFavorite = true
        } catch {
            present(error: error)
        }
    }

    func removeFromFavorites() {
        do {
            try coreDataService.remove(race: race)
            isFavorite = false
        } catch {
            present(error: error)
        }
    }

    func refreshFavoriteState() {
        do {
            let favoriteRaces = try coreDataService.fetch()
            isFavorite = favoriteRaces.contains(race)
        } catch {
            present(error: error)
        }
    }

    private func present(error: Error) {
        NSLog(error.localizedDescription)
        errorMessage = Localizable.persistenceErrorDescription
        shouldPresentAlert = true
    }
}
