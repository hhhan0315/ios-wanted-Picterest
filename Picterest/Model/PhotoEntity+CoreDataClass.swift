//
//  PhotoEntity+CoreDataClass.swift
//  Picterest
//
//  Created by rae on 2022/07/27.
//

import Foundation
import CoreData

@objc(PhotoEntity)
public class PhotoEntity: NSManagedObject {

}

extension PhotoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoEntity> {
        return NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var memo: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var date: Date?

}

extension PhotoEntity : Identifiable {

}

extension PhotoEntity {
    func toPhotoEntityData() -> PhotoEntityData {
        return PhotoEntityData(id: id ?? "",
                               memo: memo ?? "",
                               imageURL: imageURL ?? "",
                               date: date ?? Date())
    }
}
