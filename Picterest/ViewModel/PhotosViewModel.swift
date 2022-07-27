//
//  PhotosViewModel.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import Foundation
import Combine

final class PhotosViewModel {
    @Published var photoResponses: [PhotoResponse]
    private var page: Int
    private let networkManager: NetworkManager
    
    init() {
        self.photoResponses = []
        self.page = 1
        self.networkManager = NetworkManager()
    }
    
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
}
