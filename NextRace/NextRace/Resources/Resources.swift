//
//  Resources.swift
//  NextRace
//
//  Created by Redouane on 31/01/2025.
//

import SwiftUI

enum CustomFonts {
    static let body = "FugazOne-Regular"
}

enum CustomColors {
    static let backgroundColor = Color("Background-color", bundle: .main)
    static let offWhite = Color("Off-white", bundle: .main)
}

enum Localizable {
    static let undeterminedErrorDescription = NSLocalizedString(
        "races.errors.undetermined.description",
        comment: ""
    )

    static let persistenceErrorDescription = NSLocalizedString(
        "races.persistence.errors.undetermined.description",
        comment: ""
    )

    static let backButtonTitle = NSLocalizedString(
        "race-detail.back-button.title",
        comment: ""
    )
}
