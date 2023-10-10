//
//  DetailViewModel.swift
//  Litres
//
//  Created by Grigoriy Shilyaev on 10.10.23.
//

import Foundation

final class DetailViewModel: ObservableObject {
    @Published var image: Images
    
    init(image: Images) {
        self.image = image
    }
}
