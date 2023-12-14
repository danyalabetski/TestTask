//
//  Coordinator.swift
//  TestTask
//
//  Created by Даниэл Лабецкий on 13.12.2023.
//

import Foundation
import UIKit

final class Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let view = MainViewController()
        let viewModel = MainViewModel()
        
        view.viewModel = viewModel
        
        navigationController.pushViewController(view, animated: true)
        
        viewModel.transition.showPhotoLibrary = { [weak self] in
            self?.navigationController.present(view.picker, animated: true)
        }
        
        viewModel.transition.closePhotoLibrary = { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
    }
}
