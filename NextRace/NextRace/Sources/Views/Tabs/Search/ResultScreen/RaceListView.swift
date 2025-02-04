//
//  RaceListView.swift
//  NextRace
//
//  Created by Redouane on 03/02/2025.
//

import SwiftUI

struct RaceListView: View {
    @ObservedObject private var viewModel: RaceListViewModel

    init(viewModel: RaceListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            RacesListView(races: viewModel.races)
                .customNavigationBar(navigationTitle: Localizable.raceListNavigationTitle)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text(Localizable.backButtonTitle).opacity(0)
                    }
                }
        }
    }
}

struct RacesListView: View {
    let races: [Race]

    var body: some View {
        ZStack {
            CustomColors.backgroundColor.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(races) { race in
                        NavigationLink {
                            RaceItemDetailView(viewModel: .init(race: race))
                        } label: {
                            RaceItemView(item: race)
                        }
                    }
                }
            }
        }
    }
}

extension Array<Race> {
    static let forPreview: [Race] = [.nascarCupSeries, .nascarXfinitySeries]
}

private extension Localizable {
    static let raceListNavigationTitle = NSLocalizedString(
        "search.result-list.screen-title",
        comment: ""
    )
}

#Preview {
    RaceListView(viewModel: .init(races: .forPreview))
}
