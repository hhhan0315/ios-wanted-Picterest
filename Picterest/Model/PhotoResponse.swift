//
//  PhotoResponse.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import Foundation

struct PhotoResponse: Decodable {
    let id: String
    let urls: URLs
    let width: Int
    let height: Int
}

struct URLs: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

extension PhotoResponse: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PhotoResponse, rhs: PhotoResponse) -> Bool {
        return lhs.id == rhs.id
    }
}
