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
    
    enum Section {
        case main
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: createLayoutSection())
        
        let longPressGesutre = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.addGestureRecognizer(longPressGesutre)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotoEntityData>?
    
    private let viewModel = SavedViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Override Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        viewModel.fetch()
    }
    
    // MARK: - Configure Method
    
    private func configure() {
        configureView()
        configureNavigation()
        addSubviews()
        makeConstraints()
        bind()
        configureNotificationCenter()
        configureDataSource()
    }
}

// MARK: - UI Method

extension SavedViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigation() {
        navigationItem.title = "Saved Images"
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, PhotoEntityData>(collectionView: collectionView, cellProvider: { collectionView, indexPath, photoEntityData in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return .init()
            }
            
            cell.configureCell(photoEntityData: photoEntityData)
            return cell
        })
    }
}

// MARK: - bind Method

extension SavedViewController {
    private func bind() {
        viewModel.$photoEntityData
            .receive(on: DispatchQueue.main)
            .sink { photoEntityData in
                var snapShot = NSDiffableDataSourceSnapshot<Section, PhotoEntityData>()
                snapShot.appendSections([Section.main])
                snapShot.appendItems(photoEntityData)
                self.dataSource?.apply(snapShot)
            }
            .store(in: &cancellable)
    }
}

// MARK: - Method

extension SavedViewController {
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(photoSaveSuccess), name: Notification.Name.photoSaveSuccess, object: nil)
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
                self.viewModel.deletePhotoEntityData(index: indexPath.item)
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

// MARK: - UICollectionViewDataSource

//extension SavedViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.photoEntitiesCount()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
//            return .init()
//        }
//        
//        let photoEntity = viewModel.photoEntity(at: indexPath.row)
//        cell.configureCell(photoEntity: photoEntity)
//        
//        return cell
//    }
//}
