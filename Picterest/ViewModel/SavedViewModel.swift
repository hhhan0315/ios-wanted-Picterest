//
//  SavedViewModel.swift
//  Picterest
//
//  Created by rae on 2022/07/27.
//

import Foundation

final class SavedViewModel {
    @Published var photoEntities: [PhotoEntity]
    
    init() {
        self.photoEntities = []
    }
    
    func photoEntitiesCount() -> Int {
        return photoEntities.count
    }
    
    func photoEntity(at index: Int) -> PhotoEntity {
        return photoEntities[index]
    }
    
    func fetch() {
        photoEntities = CoreDataManager.shared.fetchPhotoEntity()
    }
    
    func deletePhotoEntity(index: Int) {
        let photoEntity = photoEntities[index]
        ImageFileManager.shared.deleteImage(id: photoEntity.id ?? "")
        CoreDataManager.shared.deletePhotoEntity(photoEntity: photoEntity) {
            self.photoEntities.remove(at: index)
        }
    }
}
