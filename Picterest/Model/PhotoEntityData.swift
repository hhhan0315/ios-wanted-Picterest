//
//  PhotoEntityData.swift
//  Picterest
//
//  Created by rae on 2022/07/27.
//

import Foundation

struct PhotoEntityData {
    let id: String
    let memo: String
    let imageURL: String
    let date: Date
}

extension PhotoEntityData: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PhotoEntityData, rhs: PhotoEntityData) -> Bool {
        return lhs.id == rhs.id
    }
}
