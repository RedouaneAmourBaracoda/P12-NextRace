//
//  ResultListViewModel.swift
//  NextRace
//
//  Created by Redouane on 03/02/2025.
//

import SwiftUI

final class ResultListViewModel: ObservableObject {

    // MARK: - Properties

    let races: [Race]

    // MARK: - Initialization

    init(races: [Race]) {
        self.races = races
    }
}
