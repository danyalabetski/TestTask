//
//  ViewModel.swift
//  TestTask
//
//  Created by Даниэл Лабецкий on 13.12.2023.
//

import Foundation

final class MainViewModel {
    // MARK: - Property

    var networkManager = NetworkManager()

    var modelPhotos: [ContentPhotos] = []
    var updateTableView: (() -> Void)?

    var idUser = Int()
    var nameUser = String()

    // MARK: - Transition

    var transition = Transition()

    struct Transition {
        var showPhotoLibrary: (() -> Void)?
        var closePhotoLibrary: (() -> Void)?
    }

    // MARK: - Init

    init() {
        self.networkManager = NetworkManager()
        getPhotoTypeRequest()
    }

    // MARK: - Method

    private func getPhotoTypeRequest() {
        DispatchQueue.global().async { [weak self] in
            self?.networkManager.getPhotoTypeRequest { [weak self] result in
                switch result {
                case .success(let data):
                    self?.modelPhotos = data.content
                    self?.updateTableView?()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func paginationTableView() {
        networkManager.getPhotoTypeRequest { [weak self] result in
            guard let self else { return }

            guard !networkManager.isPaginating else { return }

            switch result {
            case .success(let success):
                modelPhotos.append(contentsOf: success.content)
                updateTableView?()
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
