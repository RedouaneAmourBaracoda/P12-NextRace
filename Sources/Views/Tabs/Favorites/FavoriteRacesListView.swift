//
//  FavoriteRacesListView.swift
//  NextRace
//
//  Created by Redouane on 06/02/2025.
//

import SwiftUI

struct FavoriteRacesListView: View {
    @ObservedObject private var viewModel = FavoriteRacesListViewModel()

    var body: some View {
        NavigationStack {
            content()
                .customNavigationBar(navigationTitle: Localizable.raceListNavigationTitle)
                .alert(isPresented: $viewModel.shouldPresentAlert) {
                    Alert(title: Text(Localizable.errorAlertTitle), message: Text(viewModel.errorMessage))
                }
                .onAppear {
                    viewModel.refreshRaces()
                    viewModel.sendScreenEventAnalytics()
                }
        }
    }

    @ViewBuilder
    private func content() -> some View {
        if viewModel.favoriteRaces.isEmpty {
            Text(Localizable.emptyListMessage)
                .padding()
        } else {
            list()
        }
    }

    private func list() -> some View {
        ZStack {
            CustomColors.backgroundColor.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.favoriteRaces) { race in
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

private extension Localizable {
    static let emptyListMessage = NSLocalizedString(
        "favorite-races.empty-list.message",
        comment: ""
    )
}

#Preview {
    FavoriteRacesListView()
}
