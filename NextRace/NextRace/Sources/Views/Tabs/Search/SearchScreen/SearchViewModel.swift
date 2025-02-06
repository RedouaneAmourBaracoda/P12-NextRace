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

    @Published var searchResult: SearchResult?

    @Published var selectedChampionship: Championship = .formula

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
            searchResult = try await raceAPIService.fetchRaces(for: selectedChampionship.rawValue, at: 0)
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
        searchResult = nil
    }
}

enum Championship: String, CaseIterable, Identifiable {
    case formula
    case monster
    case nascar

    var id: Self {
        return self
    }

    var imageName: String {
        switch self {
        case .formula:
            "Formula-image"
        case .monster:
            "Monster-image"
        case .nascar:
            "Nascar-image"
        }
    }
}
