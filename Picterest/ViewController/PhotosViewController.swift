//
//  PhotosViewController.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import UIKit
import Combine

final class PhotosViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = PhotosViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        viewModel.fetch()
    }
}

// MARK: - Private

extension PhotosViewController {
    private func configure() {
        configureCollectionView()
        bind()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
    }
    
    private func bind() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }
            .store(in: &cancellable)
    }
}

// MARK: - UICollectionViewDataSource

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photosCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photo = viewModel.photo(at: indexPath.row)
        cell.configureCell(photo)
        
        return cell
    }
}
