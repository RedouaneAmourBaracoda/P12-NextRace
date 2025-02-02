//
//  SearchViewModel.swift
//  NextRace
//
//  Created by Redouane on 31/01/2025.
//

import SwiftUI

@MainActor
final class SearchViewModel: ObservableObject {

    // MARK: - Properties

    @Published var races: SearchResult?

    @Published var selectedChampionship: Championship = .nascar

    @Published var searchInProgress = false

    @Published var showRaces = false

    @Published var shouldPresentAlert = false

    var errorMessage: String = ""

    // MARK: - Services

    private let raceAPIService: RaceAPIService

    // MARK: - Initialization

    init(raceAPIService: RaceAPIService = TicketMasterAPIService()) {
        self.raceAPIService = raceAPIService
    }

    // MARK: - Methods

    func getRaces() async {

        searchInProgress = true

        do {
            races = try await raceAPIService.fetchRaces(for: selectedChampionship)
            searchInProgress = false
            showRaces = true
        } catch {
            if let raceAPIError = error as? (any RaceAPIError) {
                NSLog(raceAPIError.errorDescription ?? Localizable.undeterminedErrorDescription)
                errorMessage = raceAPIError.userFriendlyDescription
            } else {
                errorMessage = Localizable.undeterminedErrorDescription
            }
            shouldPresentAlert = true
            resetState()
        }
    }

    func resetState() {
        searchInProgress = false
        showRaces = false
        races = nil
    }
}

enum Championship: String, CaseIterable, Identifiable {
    case nascar
    case formula

    var id: Self {
        return self
    }
}
