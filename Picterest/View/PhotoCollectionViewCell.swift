//
//  PhotoCollectionViewCell.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: PhotoCollectionViewCell.self)
    
    @IBOutlet weak var lazyImageView: LazyImageView!
}

// MARK: - Public

extension PhotoCollectionViewCell {
    func configureCell(_ photo: Photo) {
        lazyImageView.loadImage(photo.urls.small)
    }
}
