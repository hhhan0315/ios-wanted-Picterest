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
    
    init() {
        self.photos = []
        self.page = 1
        self.networkManager = NetworkManager()
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
                photoResponses.forEach {
                    var photo = $0.toPhoto()
                    
                    guard let url = URL(string: photo.url) else {
                        return
                    }

                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data {
                            photo.image = UIImage(data: data)
                            self?.photos.append(photo)
                        }
                    }.resume()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
