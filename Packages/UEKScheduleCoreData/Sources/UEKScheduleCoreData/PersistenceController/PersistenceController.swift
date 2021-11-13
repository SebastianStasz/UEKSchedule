//
//  PersistenceController.swift
//  UEKScheduleCoreData
//
//  Created by Sebastian Staszczyk on 09/11/2021.
//

import CoreData
import Foundation

public final class PersistenceController {
    public static let shared = PersistenceController()

    private var container: NSPersistentContainer!

    public var context: NSManagedObjectContext {
        container.viewContext
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name:"UEKScheduleCoreData", managedObjectModel: getNSManagedObjectModel())

        if inMemory { container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null") }

        container.loadPersistentStores { storeDescription, error in
            guard let error = error else { return }
            fatalError("Loading persistent stores error: \(error)")
        }
    }

    func save() {
        do { try context.save() }
        catch let error { fatalError("Saving context error: \(error)") }
    }

    private func getNSManagedObjectModel() -> NSManagedObjectModel {
        let modelURL = getModelURL()
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to initialize managed object model from path: \(modelURL)")
        }
        return model
    }

    private func getModelURL() -> URL {
        guard let url = Bundle.module.url(forResource:"UEKScheduleCoreData", withExtension: "momd") else {
            fatalError("Failed to find url for the resource HeavyLog.momd")
        }
        return url
    }
}

