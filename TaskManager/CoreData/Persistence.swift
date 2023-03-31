//
//  Persistence.swift
//  TaskManager
//
//  Created by Berke Üçvet on 14.03.2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    
    static var preview: PersistenceController = {
        
        // Create an instance of the provider that runs in memory only
        let storageProvider = PersistenceController(inMemory: true)
        
        // Add a few test movies
        let action = Action(context: storageProvider.container.viewContext)
        action.timestamp = Date()
        action.type = "start"
        action.id = UUID()
        
        // Now save these movies in the Core Data store
        do {
            try storageProvider.container.viewContext.save()
        } catch {
            // Something went wrong 😭
            print("Failed to save test movies: \(error)")
        }

        return storageProvider
    }()
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TaskManager")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
