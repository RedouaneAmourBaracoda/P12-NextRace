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

    @Published var selectedCar: Championship = .nascar

    @Published var selectedCountry: Country = .usa

    @Published var searchInProgress = false

    @Published var showRaces = false
}

enum Championship: String, CaseIterable, Identifiable {
    case nascar
    case formula
    case wec
    case rally

    var id: Self {
        return self
    }
}

enum Country: String, CaseIterable, Identifiable {
    case usa
    case australia
    case uk

    var id: Self {
        return self
    }

    var code: String {
        switch self {
        case .usa:
            "us"
        case .australia:
            "aus"
        case .uk:
            "uk"
        }
    }
}
