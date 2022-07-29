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
    
    // 임시 저장소
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // 임시 저장소에서 데이터 가져오기 (Read)
    func fetchPhotoEntity() -> [PhotoEntity] {
        let request = PhotoEntity.fetchRequest()
        // 정렬을 date 기준으로 내림차순
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
    
    // 데이터 생성하기 (Create)
    func savePhotoEntity(photo: Photo) {
        let entity = NSEntityDescription.entity(forEntityName: CoreDataConstants.entityName, in: context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(photo.id, forKey: "id")
            managedObject.setValue(photo.memo, forKey: "memo")
            managedObject.setValue(photo.imageURL, forKey: "imageURL")
            managedObject.setValue(photo.date, forKey: "date")
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // 일치하는 데이터 삭제하기 (Delete)
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
    
}
