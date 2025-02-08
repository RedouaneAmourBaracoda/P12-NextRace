//
//  Analytics.swift
//  NextRace
//
//  Created by Redouane on 08/02/2025.
//

import FirebaseAnalytics
import Foundation

final class AnalyticsService {
    static let shared = AnalyticsService()

    func logEvent(title: String, parameters: [String: Any]?) {
        Analytics.logEvent(title, parameters: parameters)
    }
}
