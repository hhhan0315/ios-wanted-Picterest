//
//  PhotosViewController.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import UIKit
import Combine

final class PhotosViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
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
        configureView()
        addSubViews()
        makeConstraints()
        bind()
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func addSubViews() {
        view.addSubview(collectionView)
    }
    
    private func makeConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func bind() {
        viewModel.$photoResponses
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
        return viewModel.photoResponsesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photoResponse = viewModel.photoResponse(at: indexPath.row)
        cell.configureCell(index: indexPath.row, photoResponse: photoResponse)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.item >= viewModel.photoResponsesCount() - 1 else {
            return
        }
        viewModel.fetch()
    }
}

// MARK: - PinterestLayoutDelegate

extension PhotosViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = (view.bounds.width - 4) / 2
        let imageHeight: CGFloat = CGFloat(viewModel.photoResponse(at: indexPath.item).height)
        let imageWidth: CGFloat = CGFloat(viewModel.photoResponse(at: indexPath.item).width)
        let imageRatio = imageHeight / imageWidth
        
        return imageRatio * cellWidth
    }
}

// MARK: - PhotoCollectionViewCellDelegate

extension PhotosViewController: PhotoCollectionViewCellDelegate {
    func cellStarButtonClicked(index: Int) {
        let alertController = UIAlertController(title: "메모 입력", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
//            print(alertController.textFields?.first?.text)
        }))
        self.present(alertController, animated: true)
    }
}
