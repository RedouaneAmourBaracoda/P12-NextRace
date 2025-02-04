//
//  ResultListView.swift
//  NextRace
//
//  Created by Redouane on 03/02/2025.
//

import SwiftUI

struct ResultListView: View {
    @ObservedObject private var viewModel: ResultListViewModel

    init(viewModel: ResultListViewModel) {
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

extension Localizable {
    static let raceListNavigationTitle = NSLocalizedString(
        "search.result-list.screen-title",
        comment: ""
    )
}

#Preview {
    ResultListView(viewModel: .init(races: .forPreview))
}
