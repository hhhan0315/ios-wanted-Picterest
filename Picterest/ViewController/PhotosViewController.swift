//
//  PhotosViewController.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import UIKit
import Combine

final class PhotosViewController: UIViewController {
    // MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private let viewModel = PhotosViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Override Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        viewModel.fetch()
    }
}

// MARK: - UI Method

extension PhotosViewController {
    private func configure() {
        configureView()
        addSubviews()
        makeConstraints()
        bind()
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
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: - bind Method

extension PhotosViewController {
    private func bind() {
        viewModel.$photoResponses
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadSections(IndexSet(0...0))
            }
            .store(in: &cancellable)
        
        viewModel.$photoSaveSuccessTuple
            .receive(on: DispatchQueue.main)
            .sink { photoSaveSuccess in
                guard let success = photoSaveSuccess.success, let index = photoSaveSuccess.index else {
                    return
                }
                if success {
                    self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                } else {
                    let alertController = UIAlertController(title: "사진 저장 실패", message: "동일한 사진이 존재합니다.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alertController, animated: true)
                }
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
            return .init()
        }
        
        let photoResponse = viewModel.photoResponse(at: indexPath.item)
        cell.configureCell(index: indexPath.item, photoResponse: photoResponse)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.photoResponsesCount() - 1 {
            viewModel.fetch()
        }
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
        let alertController = UIAlertController(title: "메모 입력", message: "\(index + 1)번째 사진을 추가하시겠습니까?", preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.viewModel.savePhotoResponse(index: index, memo: alertController.textFields?.first?.text ?? "")
        }))
        self.present(alertController, animated: true)
    }
}
