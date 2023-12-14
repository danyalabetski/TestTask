//
//  Model.swift
//  TestTask
//
//  Created by Даниэл Лабецкий on 13.12.2023.
//

import Foundation

struct ModelPhotos: Codable {
    let content: [ContentPhotos]
}

// MARK: - Content
struct ContentPhotos: Codable {
    let id: Int
    let name: String
    let image: String?
}
