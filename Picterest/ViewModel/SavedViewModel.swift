//
//  SavedViewModel.swift
//  Picterest
//
//  Created by rae on 2022/07/27.
//

import Foundation

final class SavedViewModel {
    
    // MARK: - Properties
    
//    @Published var photoEntities: [PhotoEntity]
    @Published var photoEntityData: [PhotoEntityData]
    
    init() {
        self.photoEntityData = []
    }
    
    // MARK: - Method
    
    func photoEntityDataCount() -> Int {
        return photoEntityData.count
    }
    
    func photoEntityData(at index: Int) -> PhotoEntityData {
        return photoEntityData[index]
    }
    
    func fetch() {
        let photoEntityData = CoreDataManager.shared.fetchPhotoEntity().map { $0.toPhotoEntityData() }
        self.photoEntityData = photoEntityData
    }
    
    func deletePhotoEntityData(index: Int) {
        let photoEntityData = photoEntityData[index]
        let id = photoEntityData.id
        
        ImageFileManager.shared.existImageInFile(id: id) { exist in
            if exist {
                ImageFileManager.shared.deleteImage(id: id)
                CoreDataManager.shared.deletePhotoEntity(photoEntityData: photoEntityData) { success in
                    if success {
                        self.photoEntityData.remove(at: index)
                        NotificationCenter.default.post(name: NSNotification.Name.photoDeleteSuccess, object: nil)
                    }
                }
            }
        }
    }
}
