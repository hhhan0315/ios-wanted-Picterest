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
    private var page: Int
    private let networkManager: NetworkManager
    
    init() {
        self.photoResponses = []
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
        
        ImageLoadManager().load(photoResponse.urls.small) { data in
            
            ImageFileManager.shared.saveImage(id: photoResponse.id, data: data) { success in
                if success {
                    let photo = Photo(id: photoResponse.id,
                                      memo: memo,
                                      imageURL: photoResponse.urls.thumb,
                                      date: Date())
                    
                    CoreDataManager.shared.savePhotoEntity(photo: photo) {
                    }
                }
            }
        }
    }
}
