//
//  SavedViewController.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import UIKit

final class SavedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
}

// MARK: - Private

extension SavedViewController {
    private func configure() {
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
}
