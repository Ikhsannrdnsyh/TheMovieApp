//
//  CoreDataManager.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import CoreData

@MainActor
public final class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    private init() {}
    
    public lazy var persistentContainer: NSPersistentContainer = {
        ValueTransformer.setValueTransformer(IntArrayTransformer(), forName: NSValueTransformerName("IntArrayTransformer"))
        let modelName = "MovieModel"
        
        guard let modelURL = Bundle(for: CoreDataManager.self).url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Gagal memuat model Core Data \(modelName). Pastikan model tersedia di project.")
        }
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Core Data Load Error: \(error.localizedDescription), \(error.userInfo)")
            } else {
                print("Core Data Loaded Successfully at \(storeDescription.url?.absoluteString ?? "Unknown URL")")
            }
        }
        
        return container
    }()
    
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("✅ Core Data Saved Successfully")
            } catch {
                let nserror = error as NSError
                print("❌ Failed to save Core Data: \(nserror.localizedDescription), \(nserror.userInfo)")
            }
        }
    }
}
