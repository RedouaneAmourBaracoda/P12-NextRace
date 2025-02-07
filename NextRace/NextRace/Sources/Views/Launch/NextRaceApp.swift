//
//  NextRaceApp.swift
//  NextRace
//
//  Created by Redouane on 31/01/2025.
//

import SwiftUI

// A faire :
// - Unit tests du calendar (voir sur internet ou Mock).
// - CI : créer un fichier .yml et y coller le code proposer par github action.
// - GitHub : Security checks -> Dans l'onglet settings du repo, rentrer les régles de sécurité pour la branche main.
// - CoreData Ajoutter l'optionel sur les champs qui le sont (Price, Date)

@main
struct NextRaceApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                SearchView()
                    .tabItem { Text(Localizable.searchTabBarItemTitle) }
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
}
