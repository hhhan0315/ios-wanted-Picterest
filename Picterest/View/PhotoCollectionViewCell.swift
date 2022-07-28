//
//  PhotoCollectionViewCell.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import UIKit

protocol PhotoCollectionViewCellDelegate: AnyObject {
    func cellStarButtonClicked(index: Int)
}

final class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: PhotoCollectionViewCell.self)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.addTarget(self, action: #selector(touchStarButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starButton, infoLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .black
        stackView.layer.opacity = 0.6
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return stackView
    }()
    
    private var imageLoadManager = ImageLoadManager()
    
    weak var delegate: PhotoCollectionViewCellDelegate?
    
    private var currentIndex = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

extension PhotoCollectionViewCell {
    private func configure() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(topStackView)
    }
    
    private func makeConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            topStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            topStackView.heightAnchor.constraint(equalToConstant: 30.0),
        ])
    }
    
    @objc private func touchStarButton(_ sender: UIButton) {
//        sender.isSelected.toggle()
//        sender.tintColor = sender.isSelected ? .systemYellow : .white
        delegate?.cellStarButtonClicked(index: currentIndex)
    }
}

// MARK: - Public

extension PhotoCollectionViewCell {
    func configureCell(index: Int, photoResponse: PhotoResponse) {
        currentIndex = index
        infoLabel.text = "\(index + 1)번째 사진"
        
        imageLoadManager.load(photoResponse.urls.thumb) { [weak self] data in
            DispatchQueue.main.async {
                self?.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func configureCell(photoEntity: PhotoEntity) {
        starButton.isSelected = true
        starButton.tintColor = .systemYellow
        
        infoLabel.text = photoEntity.memo
        imageView.image = ImageFileManager.shared.fetchImage(id: photoEntity.id ?? "")
    }
}
