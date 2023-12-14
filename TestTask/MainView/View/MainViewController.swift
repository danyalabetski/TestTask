//
//  ViewController.swift
//  TestTask
//
//  Created by Даниэл Лабецкий on 13.12.2023.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: - Property
    
    var viewModel: MainViewModel!
    
    // MARK: - UIElements
    
    private let tableView = UITableView()
    var picker = UIImagePickerController()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearanceView()
        setupTableView()
        updateTableView()
    }
    
    // MARK: - Setups
    
    private func setupAppearanceView() {
        view.backgroundColor = .systemBackground
    }
    
    private func updateTableView() {
        viewModel.updateTableView = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.shared)
        view.addSubview(tableView)
    }
    
    private func setupImagePicker() {
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .camera
        
        viewModel.transition.showPhotoLibrary?()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.modelPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CustomTableViewCell.shared,
                for: indexPath
            )
            as? CustomTableViewCell
        else {
            return UITableViewCell()
        }
        
        let photos = viewModel.modelPhotos[indexPath.row]
            
        cell.setupLabels(
            image: photos.image ?? "",
            id: photos.id, name:
            photos.name
        )
        
        cell.tappedCell = { [weak self] in
            guard let self = self else { return }
            
            viewModel.idUser = photos.id
            viewModel.nameUser = photos.name
            
            setupImagePicker()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension MainViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        Task {
            try await viewModel.networkManager?.sendPhotoToServer(
                id: viewModel.idUser,
                photo: image, name:
                viewModel.nameUser
            )
        }
        
        viewModel.transition.closePhotoLibrary?()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewModel.transition.closePhotoLibrary?()
    }
}
