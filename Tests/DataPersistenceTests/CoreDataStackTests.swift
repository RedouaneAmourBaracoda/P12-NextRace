//
//  CoreDataStackTests.swift
//  NextRaceTests
//
//  Created by Redouane on 06/02/2025.
//

@testable import NextRace
import CoreData
import XCTest

final class CoreDataStackTests: XCTestCase {

    var coreDataStack: CoreDataStack!

    override func setUpWithError() throws {
        let description = NSPersistentStoreDescription()

        description.url = URL(fileURLWithPath: "/dev/null")

        let container = NSPersistentContainer(name: NSPersistentContainer.PersistentKeys.persitentContainerName)

        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        coreDataStack = CoreDataStack(persistentContainer: container)
    }

    func testSaveRaces() throws {
        // Given.

        let race: Race = .random()

        // When.

        try coreDataStack.add(newRace: race)

        // Then.

        let races = try coreDataStack.fetch()

        XCTAssertEqual(1, races.count)

        XCTAssertTrue(races.contains(race))
    }

    func testRemoveRaces() throws {
        // Given.

        let race1: Race = .random()

        let race2: Race = .random()

        // When.

        try coreDataStack.add(newRace: race1)

        try coreDataStack.add(newRace: race2)

        let races = try coreDataStack.fetch()

        XCTAssertEqual(2, races.count)

        XCTAssertTrue(races.contains(race1))

        XCTAssertTrue(races.contains(race2))

        try coreDataStack.remove(race: race1)

        try coreDataStack.remove(race: race2)

        let finalRaces = try coreDataStack.fetch()

        // Then.

        XCTAssertEqual(0, finalRaces.count)

        XCTAssertFalse(finalRaces.contains(race1))

        XCTAssertFalse(finalRaces.contains(race2))
    }
}
