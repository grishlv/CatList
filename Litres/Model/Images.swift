//
//  Images.swift
//  Litres
//
//  Created by Grigoriy Shilyaev on 08.10.23.
//

import Foundation

struct Images: Decodable, Identifiable, Equatable {
    let id: String
    let url: String
    let height: Int
    let width: Int
    let breeds: [Breed]?
}
