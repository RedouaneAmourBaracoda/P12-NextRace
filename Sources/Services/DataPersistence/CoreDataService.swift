//  CoreDataService.swift
//  NextRace
//
//  Created by Redouane on 06/02/2025.
//

import CoreData
import Foundation

protocol CoreDataService {
    func add(newRace: Race) throws

    func remove(race: Race) throws

    func fetch() throws -> [Race]
}

final class CoreDataStack: CoreDataService {
    var persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    init(persistentContainer: NSPersistentContainer = .FavoriteRacesContainer) {
        self.persistentContainer = persistentContainer
    }

    static let shared: CoreDataStack = CoreDataStack()

    func add(newRace: Race) throws {
        let dto = FavoriteRace(context: context)
        dto.id = newRace.id
        dto.name = newRace.name
        dto.imageURL = newRace.imageURL
        dto.seatmapURL = newRace.seatmapURL
        dto.date = newRace.date
        if let venue = newRace.venue {
            dto.venue = try JSONEncoder().encode(venue)
        }
        if let price = newRace.price {
            dto.price = try JSONEncoder().encode(price)
        }
        print("\(newRace.name) was successfully encoded.")

        try context.save()
        print("\(newRace.name) was successfully added.")
    }

    func remove(race: Race) throws {
        let request: NSFetchRequest<FavoriteRace> = FavoriteRace.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", race.id)
        let favoriteRaces = try context.fetch(request)
        for favoriteRace in favoriteRaces where favoriteRace.id == race.id {
            context.delete(favoriteRace)
        }
        try context.save()
        print("\(race.name) was successfully removed.")
    }

    func fetch() throws -> [Race] {
        let request: NSFetchRequest<FavoriteRace> = FavoriteRace.fetchRequest()
        let favoriteRaces = try context.fetch(request)

        return try favoriteRaces.compactMap {
            guard
                let id = $0.id,
                let name = $0.name
            else {
                print("Failed to load one race into Database")
                return nil
            }

            var venue: Race.Venue? = nil
            if let venueData = $0.venue {
                venue = try JSONDecoder().decode(Race.Venue.self, from: venueData)
            }

            var price: PriceRanges? = nil
            if let priceData = $0.price {
                price = try JSONDecoder().decode(PriceRanges.self, from: priceData)
            }

            return Race(
                id: id,
                name: name,
                imageURL: $0.imageURL,
                venue: venue,
                date: $0.date,
                seatmapURL: $0.seatmapURL,
                price: price
            )
        }
    }
}

extension NSPersistentContainer {
    enum PersistentKeys {
        static let persitentContainerName = "FavoriteRaces"
    }

    static let FavoriteRacesContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: PersistentKeys.persitentContainerName)
        container.loadPersistentStores { storeDescription, error in

            print("Loading store \(storeDescription.description) ...")
            if let error = error as? NSError {
                fatalError("Found error while loading persistent store : \(error.userInfo)")
            }

            print("Successfully loaded store : \(storeDescription.description)")
        }
        return container
    }()
}
