//
//  NetworkManager.swift
//  TestTask
//
//  Created by Даниэл Лабецкий on 13.12.2023.
//

import Foundation
import UIKit

enum Constants {
    static let apiForGetRequest = "https://junior.balinasoft.com/api/v2/photo/type"
    static let apiForPostRequest = "https://junior.balinasoft.com/api/v2/photo"
}

final class NetworkManager {
    var isPaginating = false

    func getPhotoTypeRequest(pagination: Bool = false, _ completion: @escaping ((Result<ModelPhotos, Error>) -> Void)) {
        if pagination {
            isPaginating = true
        }

        guard let url = URL(string: Constants.apiForGetRequest) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard
                error == nil,
                let data = data
            else {
                return
            }

            do {
                let data = try JSONDecoder().decode(ModelPhotos.self, from: data)
                completion(.success(data))
                if pagination {
                    self.isPaginating = false
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func sendPhotoToServer(id: Int, photo: UIImage, name: String) async throws {
        guard let imageData = photo.jpegData(compressionQuality: 0.8),
              let url = URL(string: Constants.apiForPostRequest)
        else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = .post

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: .contentType)

        var body = Data()

        appendFormField(name: .typeId, value: "\(id)", boundary: boundary, body: &body)

        appendFormField(name: .name, value: name, boundary: boundary, body: &body)

        appendFileField(
            name: .photo,
            filename: .photoJpg,
            mimeType: .imageJpeg,
            data: imageData,
            boundary: boundary,
            body: &body
        )

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("Response: \(jsonResponse)")
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    private func appendFormField(
        name: String,
        value: String,
        boundary: String,
        body: inout Data
    ) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }

    private func appendFileField(
        name: String,
        filename: String,
        mimeType: String,
        data: Data,
        boundary: String,
        body: inout Data
    ) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
    }
}
