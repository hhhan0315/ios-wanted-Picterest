//
//  MainTabBarController.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
}

// MARK: - Private

extension MainTabBarController {
    private func configure() {
        configureUI()
    }
    
    private func configureUI() {
        let photosTabBarItem = UITabBarItem(title: MainTabBarItem.photo.title, image: MainTabBarItem.photo.image, selectedImage: nil)
        let savedTabBarItem = UITabBarItem(title: MainTabBarItem.saved.title, image: MainTabBarItem.saved.image, selectedImage: nil)
        
        let photosViewController = PhotosViewController()
        photosViewController.tabBarItem = photosTabBarItem
        
        let savedViewController = SavedViewController()
        savedViewController.tabBarItem = savedTabBarItem
        
        viewControllers = [photosViewController, savedViewController]
    }
}
