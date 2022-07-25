//
//  Photo.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import Foundation

struct Photo: Decodable {
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
