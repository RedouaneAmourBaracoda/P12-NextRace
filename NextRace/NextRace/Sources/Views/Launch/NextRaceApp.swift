//
//  NextRaceApp.swift
//  NextRace
//
//  Created by Redouane on 31/01/2025.
//

import SwiftUI

@main
struct NextRaceApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                SearchView()
                    .tabItem { Text(Localizable.searchTabBarItemTitle) }

                FavoriteRacesListView()
                    .tabItem { Text(Localizable.favoritesTabBarItemTitle) }
            }
            .onAppear { configureAppearance() }
        }
    }

    private func configureAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes(
            [.font: UIFont(name: CustomFonts.body, size: 30.0)!],
          for: .normal)
        UITabBar.appearance().backgroundColor = .init(CustomColors.backgroundColor)
        UITabBar.appearance().unselectedItemTintColor = .white
    }
}

private extension Localizable {
    static let searchTabBarItemTitle = NSLocalizedString(
        "tabs.search.title",
        comment: ""
    )
    static let favoritesTabBarItemTitle = NSLocalizedString(
        "tabs.favorites.title",
        comment: ""
    )
}
