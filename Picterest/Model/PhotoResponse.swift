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
