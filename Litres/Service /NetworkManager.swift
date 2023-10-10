//
//  NetworkManager.swift
//  Litres
//
//  Created by Grigoriy Shilyaev on 09.10.23.
//

import SwiftUI

protocol NetworkManagerProtocol {
    func fetchImages(completion: @escaping (Result<[Images], Error>) -> Void)
    func downloadImages(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}

enum NetworkError: Error {
    case invalidURL
    case noData
}

final class NetworkManager: NetworkManagerProtocol {
    
    private var currentPage: Int = 0
        
    func downloadImages(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            ImageCache.shared.saveImage(image, for: url.absoluteString)
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }.resume()
    }
}

extension NetworkManager {
    private var fetchImagesURL: URL? {
        let urlString = "\(Constants.baseURL)?limit=10&page=\(currentPage)"
        return URL(string: urlString)
    }
    
    private func executeDataTask(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    func fetchImages(completion: @escaping (Result<[Images], Error>) -> Void) {
        guard let url = fetchImagesURL else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(Constants.apiKey, forHTTPHeaderField: "x-api-key")
        
        executeDataTask(with: request.url!) { result in
            switch result {
            case .success(let data):
                do {
                    let images = try JSONDecoder().decode([Images].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(images))
                        self.currentPage += 1
                    }
                } catch let decodingError {
                    completion(.failure(decodingError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
