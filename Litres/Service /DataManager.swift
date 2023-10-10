//
//  DataManager.swift
//  Litres
//
//  Created by Grigoriy Shilyaev on 10.10.23.
//

import SwiftUI

final class ImageCache {
    private var cache: NSCache<NSString, UIImage> = NSCache()
    
    static let shared = ImageCache()
    
    func saveImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func getImage(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
