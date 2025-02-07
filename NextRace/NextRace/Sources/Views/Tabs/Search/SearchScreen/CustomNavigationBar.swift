//
//  CustomNavigationBar.swift
//  NextRace
//
//  Created by Redouane on 31/01/2025.
//

import SwiftUI

extension View {
    func customNavigationBar(
        navigationTitle: String,
        navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode = .inline,
        fontName: String = CustomFonts.body,
        fontSize: CGFloat = 30.0,
        foregroundColor: UIColor = .white,
        backgroundColor: UIColor = .init(CustomColors.backgroundColor)
    ) -> some View {
        modifier(CustomNavigationBarModifier(
            navigationTitle: navigationTitle,
            navigationTitleDisplayMode: navigationTitleDisplayMode,
            fontName: fontName,
            fontSize: fontSize,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor
        ))
    }
}

private struct CustomNavigationBarModifier: ViewModifier {
    private let navigationTitle: String
    private let navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode
    private let fontName: String
    private let fontSize: CGFloat
    private let foregroundColor: UIColor
    private let backgroundColor: UIColor

    init(
        navigationTitle: String,
        navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode,
        fontName: String,
        fontSize: CGFloat,
        foregroundColor: UIColor,
        backgroundColor: UIColor
    ) {
        self.navigationTitle = navigationTitle
        self.navigationTitleDisplayMode = navigationTitleDisplayMode
        self.fontName = fontName
        self.fontSize = fontSize
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    func body(content: Content) -> some View {
        content
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(navigationTitleDisplayMode)
            .onAppear {
                let appearance = UINavigationBarAppearance()

                appearance.backgroundColor = backgroundColor

                appearance.titleTextAttributes = [
                    .font: UIFont(name: fontName, size: fontSize)!,
                    .foregroundColor: foregroundColor
                ]

                UINavigationBar.appearance().standardAppearance = appearance

                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}
