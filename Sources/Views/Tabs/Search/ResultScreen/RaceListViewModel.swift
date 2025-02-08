//
//  RaceListViewModel.swift
//  NextRace
//
//  Created by Redouane on 03/02/2025.
//

import SwiftUI

@MainActor
final class RaceListViewModel: ObservableObject {

    // MARK: - Properties

    @Published var currentPage: Int

    @Published var races: [Race]

    @Published var totalPages: Int

    @Published var searchInProgress = false

    @Published var shouldPresentAlert = false

    var showLoadMore: Bool { currentPage < totalPages - 1 }

    var errorMessage: String = ""

    let selectedChampionship: Championship

    // MARK: - Services

    private let raceAPIService: RaceAPIService

    // MARK: - Initialization

    init(
        selectedChampionship: Championship,
        searchResult: SearchResult,
        raceAPIService: RaceAPIService = TicketMasterAPIService()
    ) {
        self.selectedChampionship = selectedChampionship
        self.currentPage = searchResult.page.number
        self.totalPages = searchResult.page.totalPages
        self.races = searchResult.races
        self.raceAPIService = raceAPIService
    }

    func loadmore() async {
        searchInProgress = true

        do {
            let newSearchResult = try await raceAPIService.fetchRaces(
                for: selectedChampionship.rawValue,
                at: currentPage + 1
            )
            currentPage = newSearchResult.page.number
            totalPages = newSearchResult.page.totalPages
            newSearchResult.races.forEach { races.append($0) }
            searchInProgress = false
        } catch {
            if let raceAPIError = error as? (any RaceAPIError) {
                NSLog(raceAPIError.errorDescription ?? Localizable.undeterminedErrorDescription)
                errorMessage = raceAPIError.userFriendlyDescription
            } else {
                errorMessage = Localizable.undeterminedErrorDescription
            }
            shouldPresentAlert = true
            searchInProgress = false
        }
    }
}
