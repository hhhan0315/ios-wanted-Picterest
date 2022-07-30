//
//  CoreDataManager.swift
//  Picterest
//
//  Created by rae on 2022/07/27.
//

import Foundation
import CoreData

final class CoreDataManager {
    enum CoreDataConstants {
        static let containerName = "Picterest"
        static let entityName = "PhotoEntity"
    }
    
    static let shared = CoreDataManager()
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataConstants.containerName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetchPhotoEntity() -> [PhotoEntity] {
        let request = PhotoEntity.fetchRequest()
        let dateOrder = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateOrder]
        
        do {
            let fetchResult = try context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func savePhotoEntity(photoEntityData: PhotoEntityData) {
        let entity = NSEntityDescription.entity(forEntityName: CoreDataConstants.entityName, in: context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(photoEntityData.id, forKey: "id")
            managedObject.setValue(photoEntityData.memo, forKey: "memo")
            managedObject.setValue(photoEntityData.imageURL, forKey: "imageURL")
            managedObject.setValue(photoEntityData.date, forKey: "date")
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deletePhotoEntity(photoEntity: PhotoEntity, completion: @escaping (Bool) -> Void) {
        guard let id = photoEntity.id else {
            completion(false)
            return
        }
        
        let request = PhotoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let fetchResult = try context.fetch(request)
            
            if let targetPhotoEntity = fetchResult.first {
                context.delete(targetPhotoEntity)
                
                do {
                    try context.save()
                    completion(true)
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            }
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func isExistPhotoEntity(id: String, completion: @escaping (Bool) -> Void) {
        let request = PhotoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let fetchResult = try context.fetch(request)
            
            if !fetchResult.isEmpty {
                completion(true)
            }
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
        
        completion(false)
    }
}
