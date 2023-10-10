//
//  DetailVie.swift
//  Litres
//
//  Created by Grigoriy Shilyaev on 10.10.23.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    
    var body: some View {
        VStack {
            if let imageURL = URL(string: viewModel.image.url) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable()
                            .aspectRatio(contentMode: .fit)
                    case .empty, .failure:
                        Image(systemName: "photo").resizable().aspectRatio(contentMode: .fit)
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(10)
                .padding(.horizontal)
            }
            if let breedName = viewModel.image.breeds?.first?.name {
                Text("Breed: \(breedName)")
                    .font(.headline)
                    .padding(.top, 10)
            } else {
                Text("Breed: breed is unknown")
                    .font(.headline)
                    .padding(.top, 10)
            }
        }
        .padding()
    }
}
