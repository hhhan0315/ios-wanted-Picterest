//
//  PhotosViewModel.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import Foundation

final class PhotosViewModel {
    // MARK: - Properties
    
    @Published var photoResponses: [PhotoResponse]
    @Published var photoSaveSuccessTuple: (success: Bool?, index: Int?)
    private var page: Int
    private let networkManager: NetworkManager
        
    init() {
        self.photoResponses = []
        self.photoSaveSuccessTuple = (nil, nil)
        self.page = 1
        self.networkManager = NetworkManager()
    }
    
    // MARK: - Method
    
    func photoResponsesCount() -> Int {
        return photoResponses.count
    }
    
    func photoResponse(at index: Int) -> PhotoResponse {
        return photoResponses[index]
    }
    
    func fetch() {
        let photosEndpoint = APIEndpoints.getPhotos(page: page)
        networkManager.fetchData(endpoint: photosEndpoint, dataType: [PhotoResponse].self) { [weak self] result in
            switch result {
            case .success(let photoResponses):
                self?.photoResponses.append(contentsOf: photoResponses)
                self?.page += 1
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func savePhotoResponse(index: Int, memo: String) {
        let photoResponse = photoResponse(at: index)
        let imageURL = photoResponse.urls.small
        let id = photoResponse.id
        let photo = Photo(id: id, memo: memo, imageURL: imageURL, date: Date())
        
        ImageFileManager.shared.existImageInFile(id: id) { exist in
            if !exist {
                ImageLoadManager.shared.load(imageURL) { data in
                    ImageFileManager.shared.saveImage(id: id, data: data)
                    CoreDataManager.shared.savePhotoEntity(photo: photo)
                    self.photoSaveSuccessTuple = (true, index)
                }
            } else {
                self.photoSaveSuccessTuple = (false, nil)
            }
        }
    }
}
