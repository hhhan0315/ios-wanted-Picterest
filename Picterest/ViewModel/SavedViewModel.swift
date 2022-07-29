//
//  SavedViewModel.swift
//  Picterest
//
//  Created by rae on 2022/07/27.
//

import Foundation

final class SavedViewModel {
    // MARK: - Properties
    
    @Published var photoEntities: [PhotoEntity]
    
    init() {
        self.photoEntities = []
    }
    
    // MARK: - Method
    
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
        guard let id = photoEntity.id else {
            return
        }
        
        ImageFileManager.shared.existImageInFile(id: id) { exist in
            if exist {
                ImageFileManager.shared.deleteImage(id: photoEntity.id ?? "")
                CoreDataManager.shared.deletePhotoEntity(photoEntity: photoEntity) { success in
                    if success {
                        self.photoEntities.remove(at: index)
                    }
                }
            }
        }
        
//        ImageFileManager.shared.deleteImage(id: photoEntity.id ?? "")
//        CoreDataManager.shared.deletePhotoEntity(photoEntity: photoEntity) { success in
//            if success {
//                self.photoEntities.remove(at: index)
//            }
//        }
    }
}
