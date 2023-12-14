//
//  CustomCell.swift
//  TestTask
//
//  Created by Даниэл Лабецкий on 13.12.2023.
//

import Foundation
import UIKit

final class CustomTableViewCell: UITableViewCell {
    static let shared = "CustomTableViewCell"
    
    // MARK: - Properties
    
    var tappedCell: (() -> Void)?
    
    // MARK: - UIElements
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let userIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTappedGestureRecognizer))
        addGestureRecognizer(gestureRecognizer)
   
        addSubviews(views: photoImageView, userIdLabel, nameLabel)
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            photoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            userIdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userIdLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            userIdLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func setupLabels(image: String, id: Int, name: String) {
        userIdLabel.text = String(id)
        nameLabel.text = name
        
        guard let url = URL(string: image) else { return }
        photoImageView.load(url: url)
    }
    
    // MARK: - Helpers

    @objc private func didTappedGestureRecognizer() {
        tappedCell?()
    }
}
