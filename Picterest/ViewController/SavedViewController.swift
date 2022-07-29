//
//  SavedViewController.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import UIKit
import Combine

final class SavedViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: createLayoutSection())
        
        let longPressGesutre = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.addGestureRecognizer(longPressGesutre)
        return collectionView
    }()
    
    private let viewModel = SavedViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Override Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        viewModel.fetch()
    }
}

// MARK: - UI Method

extension SavedViewController {
    private func configure() {
        configureView()
        addSubviews()
        makeConstraints()
        bind()
        configureNotificationCenter()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func makeConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.spacing),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.spacing),
        ])
    }
    
    private func createLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(488))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(488))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.spacing
        return section
    }
}

// MARK: - bind Method

extension SavedViewController {
    private func bind() {
        viewModel.$photoEntities
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadSections(IndexSet(0...0))
            }
            .store(in: &cancellable)
    }
}

// MARK: - objc Method

extension SavedViewController {
    @objc private func longPressGestureRecognized(_ sender: UILongPressGestureRecognizer) {
        let pressPoint = sender.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: pressPoint) else {
            return
        }
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        if sender.state == .began {
            UIView.animate(withDuration: 0.1) {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.1) {
                cell.transform = .identity
            }
            let alertController = UIAlertController(title: "사진 삭제", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
            alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.viewModel.deletePhotoEntity(index: indexPath.item)
            }))
            present(alertController, animated: true)
        }
    }
    
    @objc private func photoSaveSuccess() {
        viewModel.fetch()
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
}

// MARK: - Method

extension SavedViewController {
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(photoSaveSuccess), name: Notification.Name.photoSaveSuccess, object: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension SavedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoEntitiesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return .init()
        }
        
        let photoEntity = viewModel.photoEntity(at: indexPath.row)
        cell.configureCell(photoEntity: photoEntity)
        
        return cell
    }
}
