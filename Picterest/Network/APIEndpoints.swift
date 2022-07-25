//
//  APIEndpoints.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import Foundation

struct APIEndpoints {
    static func getPhotos(page: Int, perPage: Int = 15) -> Endpoint {
        return Endpoint(urlString: "https://api.unsplash.com/photos",
                        method: .get,
                        headers: ["Authorization": "Client-ID \(Constants.apiKey)"],
                        queryItems: ["page": "\(page)", "per_page": "\(perPage)"])
    }
}
