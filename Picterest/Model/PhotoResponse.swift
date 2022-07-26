//
//  Photo.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import Foundation

struct PhotoResponse: Decodable {
    let id: String
    let urls: Urls
}

struct Urls: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

extension PhotoResponse {
    func toPhoto() -> Photo {
        return Photo(id: id, image: nil, url: urls.small)
    }
}
