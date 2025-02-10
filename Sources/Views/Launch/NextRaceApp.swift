//
//  NextRaceApp.swift
//  NextRace
//
//  Created by Redouane on 31/01/2025.
//

import FirebaseCore
import SwiftUI

// TODO: - 
// - Fastlane 
// - Added-to-Calendar image bigger
// - SwiftLint : add a rule for inclusive name
// - Apply Damien comments
// - Add track logo for each championship
// - Add a sheet view for more info on championship
// - Add articles news
// - In favorite tab:  add filter -> cheapest to most expensive

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct NextRaceApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

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
