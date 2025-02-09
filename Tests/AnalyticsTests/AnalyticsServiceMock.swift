//
//  AnalyticsServiceMock.swift
//  NextRace
//
//  Created by Redouane on 09/02/2025.
//

import Foundation

final class AnalyticsServiceMock: AnalyticsService {
    var logEventClosure: ((String, [String: Any]?) -> Void)?

    var logEventCallsCounter = 0

    func logEvent(title: String, parameters: [String: Any]?) {
        logEventCallsCounter += 1
        logEventClosure?(title, parameters)
    }
}
