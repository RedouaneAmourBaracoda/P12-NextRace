//
//  SearchView.swift
//  NextRace
//
//  Created by Redouane on 31/01/2025.
//

import Firebase
import SwiftUI

struct SearchView: View {

    @ObservedObject private var viewModel: SearchViewModel = .init()

    var body: some View {
        NavigationStack {
            contentView()
                .customNavigationBar(navigationTitle: Localizable.navigationTitle)
                .alert(isPresented: $viewModel.shouldPresentAlert) {
                    Alert(title: Text(Localizable.errorAlertTitle), message: Text(viewModel.errorMessage))
                }
                .background { CustomColors.backgroundColor.ignoresSafeArea() }
        }
    }

    private func contentView() -> some View {
        VStack {
            carSelectionView()
            Spacer()
            searchActionView()
                .navigationDestination(isPresented: $viewModel.showRaces) {
                    if let searchResult = viewModel.searchResult {
                        RaceListView(
                            viewModel: .init(
                                selectedChampionship: viewModel.selectedChampionship,
                                searchResult: searchResult
                            )
                        )
                    }
                }
        }
        .onAppear { viewModel.resetState() }
        .padding(.top)
        .padding(.bottom, 0.5)
    }

    private func carSelectionView() -> some View {
        VStack {
            HStack {
                Text(Localizable.carSelectionTitle)
                    .font(.custom(CustomFonts.body, size: 25.0))
                    .foregroundStyle(.white)
                    .accessibilityLabel(Localizable.championshipSectionAccessibilityLabel)
                    .accessibilityHint(Localizable.championshipSectionAccessibilityHint)
                Spacer()
            }

            Picker(Localizable.carSelectionTitle, selection: $viewModel.selectedChampionship) {
                ForEach(Championship.allCases) {
                    Text($0.rawValue.uppercased())
                }
            }
            .pickerStyle(.segmented)

            VStack {
                Image(viewModel.selectedChampionship.carImageName, bundle: .main)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200.0)
                    .accessibilityLabel(Localizable.carImageAccessibilityLabel)
                    .accessibilityValue(viewModel.selectedChampionship.carImageName)
                    .padding()
                Image(viewModel.selectedChampionship.trackImageName, bundle: .main)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 160.0)
                    .accessibilityLabel(Localizable.carImageAccessibilityLabel)
                    .accessibilityValue(viewModel.selectedChampionship.trackImageName)
            }
            .padding()
        }
        .padding()
    }

    private func searchActionView() -> some View {
        VStack {
            if viewModel.searchInProgress {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
                    .background { Circle().foregroundStyle(.white) }
            }
            Button {
                Task {
                    await viewModel.getRaces()
                }
            } label: {
                Text(Localizable.searchButtonTitle)
                    .font(.custom(CustomFonts.body, size: 20.0))
                    .foregroundStyle(CustomColors.backgroundColor)
                    .padding(.vertical)
                    .padding(.horizontal, 80)
                    .background { viewModel.searchInProgress ? Color.gray : Color.white }
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .padding()
            }
            .disabled(viewModel.searchInProgress)
            .accessibilityHint(Localizable.searchForRacesButtonAccessibilityHint)
        }
    }
}

extension Localizable {
    static let carSelectionTitle = NSLocalizedString(
        "search.cars.title",
        comment: ""
    )

    static let countrySelectionTitle = NSLocalizedString(
        "search.country.title",
        comment: ""
    )

    static let navigationTitle = NSLocalizedString(
        "search.navigation.title",
        comment: ""
    )

    static let searchButtonTitle = NSLocalizedString(
        "search.button.title",
        comment: ""
    )

    static let errorAlertTitle = NSLocalizedString(
        "search.alert.error.title",
        comment: ""
    )
    static let searchForRacesButtonAccessibilityHint = NSLocalizedString(
        "search.button.accessibility-hint",
        comment: ""
    )
    static let championshipSectionAccessibilityLabel = NSLocalizedString(
        "search.championship-selection.accessibility-label",
        comment: ""
    )
    static let championshipSectionAccessibilityHint = NSLocalizedString(
        "search.championship-selection.accessibility-hint",
        comment: ""
    )
    static let carImageAccessibilityLabel = NSLocalizedString(
        "search.car-image.accessibility-label",
        comment: ""
    )
}

#Preview {
    SearchView()
}
