//
//  Extension+UIView.swift
//  TestTask
//
//  Created by Даниэл Лабецкий on 13.12.2023.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func maskIntoConstraints(view: UIView...) {
        view.forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
    }
}
