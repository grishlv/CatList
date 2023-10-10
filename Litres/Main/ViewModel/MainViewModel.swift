//
//  ContentViewModel.swift
//  Litres
//
//  Created by Grigoriy Shilyaev on 08.10.23.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    
    @Published var imageDictionary: [String: UIImage] = [:]
    @Published var images: [Images] = []
    @Published var isLoading: Bool = false
    private let networkService: NetworkManagerProtocol
    
    init(networkService: NetworkManagerProtocol) {
        self.networkService = networkService
    }
    
    func loadImages() {
        isLoading = true
        networkService.fetchImages { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newImages):
                    self?.images.append(contentsOf: newImages)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func cacheImage(for url: URL) {
        if let cachedImage = ImageCache.shared.getImage(for: url.absoluteString) {
            self.imageDictionary[url.absoluteString] = cachedImage
            return
        }
        
        networkService.downloadImages(url: url) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.imageDictionary[url.absoluteString] = image
                }
            case .failure(let error):
                print("Failed to download image: \(error.localizedDescription)")
            }
        }
    }
}
