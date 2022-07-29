//
//  LazyImageView.swift
//  CustomKeyboard
//
//  Created by rae on 2022/07/19.
//

import UIKit

final class LazyImageView: UIImageView {
    private var task: URLSessionDataTask?
    private let imageCacheManager = ImageCacheManager.shared
    
    func loadImage(_ urlString: String) {
        image = nil
        
        let key = urlString as NSString
        
        if let cachedData = imageCacheManager.load(key) {
            image = UIImage(data: cachedData)
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            self.imageCacheManager.save(key, data)

            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
        
        task?.resume()
    }
    
    func cancelTask() {
        task?.cancel()
        task = nil
    }
}
