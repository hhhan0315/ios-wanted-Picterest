//
//  PhotoImageView.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import UIKit

final class PhotoImageView: UIView {
    enum PhotoImageViewConstants {
        static let nibName = String(describing: PhotoImageView.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
}

// MARK: - Private

extension PhotoImageView {
    private func configure() {
        customInit()
    }
    
    private func customInit() {
        guard let view = Bundle.main.loadNibNamed(PhotoImageViewConstants.nibName, owner: self, options: nil)?.first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
    }
}
