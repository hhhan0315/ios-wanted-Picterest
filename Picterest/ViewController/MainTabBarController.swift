//
//  MainTabBarController.swift
//  Picterest
//
//  Created by rae on 2022/07/26.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    enum MainTabBarItem {
        case photo
        case saved
        
        var title: String {
            switch self {
            case .photo:
                return "Photos"
            case .saved:
                return "Saved"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .photo:
                return UIImage(systemName: "photo.fill")
            case .saved:
                return UIImage(systemName: "star.fill")
            }
        }
    }
    
    // MARK: - Override Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: - Configure Method

    private func configure() {
        configureUI()
    }
}

// MARK: - UI Method

extension MainTabBarController {
    private func configureUI() {
        let photosTabBarItem = UITabBarItem(title: MainTabBarItem.photo.title, image: MainTabBarItem.photo.image, selectedImage: nil)
        let savedTabBarItem = UITabBarItem(title: MainTabBarItem.saved.title, image: MainTabBarItem.saved.image, selectedImage: nil)
        
        let photosViewController = PhotosViewController()
        photosViewController.tabBarItem = photosTabBarItem
        let photosNavigationController = UINavigationController(rootViewController: photosViewController)
        
        let savedViewController = SavedViewController()
        savedViewController.tabBarItem = savedTabBarItem
        let savedNavigationController = UINavigationController(rootViewController: savedViewController)
        
        viewControllers = [photosNavigationController, savedNavigationController]
    }
}
