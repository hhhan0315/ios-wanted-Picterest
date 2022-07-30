//
//  PhotosViewModel.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import Foundation

final class PhotosViewModel {
    
    // MARK: - Properties
    
    @Published var photos: [Photo]
    @Published var photoSaveSuccessTuple: (success: Bool?, indexPath: IndexPath?)
    private var page: Int
    private let networkManager: NetworkManager
        
    init() {
        self.photos = []
        self.photoSaveSuccessTuple = (nil, nil)
        self.page = 1
        self.networkManager = NetworkManager()
    }
    
    // MARK: - Method
    
    func photosCount() -> Int {
        return photos.count
    }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func fetch() {
        let photosEndpoint = APIEndpoints.getPhotos(page: page)
        networkManager.fetchData(endpoint: photosEndpoint, dataType: [PhotoResponse].self) { [weak self] result in
            switch result {
            case .success(let photoResponses):
                let photos = photoResponses.map { $0.toPhoto() }
                self?.photos.append(contentsOf: photos)
                self?.page += 1
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func savePhotoResponse(indexPath: IndexPath, memo: String) {
        let photo = photo(at: indexPath.item)
        let imageURL = photo.urlSmall
        let id = photo.id
        let photoEntityData = PhotoEntityData(id: id, memo: memo, imageURL: imageURL, date: Date())
        
        ImageFileManager.shared.existImageInFile(id: id) { exist in
            if !exist {
                ImageLoadManager().load(imageURL) { data in
                    ImageFileManager.shared.saveImage(id: id, data: data)
                    CoreDataManager.shared.savePhotoEntity(photoEntityData: photoEntityData)
                    self.photoSaveSuccessTuple = (true, indexPath)
                    
                    // 뷰컨에서 델리게이트 패턴으로 전달
//                    NotificationCenter.default.post(name: Notification.Name.photoSaveSuccess, object: nil)
                }
            } else {
                self.photoSaveSuccessTuple = (false, indexPath)
            }
        }
    }
}
