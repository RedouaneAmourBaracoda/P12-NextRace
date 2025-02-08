//
//  EKEventStoreFake.swift
//  NextRace
//
//  Created by Redouane on 07/02/2025.
//

import EventKit
import Foundation

final class EKEventStoreFake: EKEventStore {
    var accessIsGranted: Bool
    var savedEvents: [EKEvent]
    var requestFullAccessToEventsError: Error?
    var saveEventsError: Error?

    init(
        accessIsGranted: Bool = false,
        savedEvents: [EKEvent] = [],
        requestFullAccessToEventsError: Error? = nil,
        saveEventsError: Error? = nil
    ) {
        self.accessIsGranted = accessIsGranted
        self.savedEvents = savedEvents
        self.requestFullAccessToEventsError = requestFullAccessToEventsError
        self.saveEventsError = saveEventsError
        super.init()
    }

    override func requestFullAccessToEvents() async throws -> Bool {
        if let requestFullAccessToEventsError { throw requestFullAccessToEventsError }
        return accessIsGranted
    }

    override func save(_ event: EKEvent, span: EKSpan) throws {
        if let saveEventsError { throw saveEventsError }
        savedEvents.append(event)
    }

    override func events(matching predicate: NSPredicate) -> [EKEvent] {
        savedEvents
    }
}
