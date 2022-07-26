//
//  PhotosViewModel.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import Foundation
import Combine
import UIKit

final class PhotosViewModel {
    @Published var photos: [Photo]
    private var page: Int
    private let networkManager: NetworkManager
    private let imageLoadManager: ImageLoadManager
    
    init() {
        self.photos = []
        self.page = 1
        self.networkManager = NetworkManager()
        self.imageLoadManager = ImageLoadManager()
    }
    
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
                var photos: [Photo] = []
                
                photoResponses.forEach {
                    var photo = $0.toPhoto()
                    
                    self?.imageLoadManager.load(photo.url) { data in
                        photo.image = UIImage(data: data)
                        photos.append(photo)
                        
                        if photos.count == 15 {
                            self?.photos.append(contentsOf: photos)
                            self?.page += 1
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
