//
//  Photo.swift
//  Picterest
//
//  Created by rae on 2022/07/30.
//

import Foundation

struct Photo {
    let uuid = UUID()
    let id: String
    let urlThumb: String
    let urlSmall: String
    let width: Int
    let height: Int
}

extension Photo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
