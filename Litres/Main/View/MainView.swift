//
//  ContentView.swift
//  Litres
//
//  Created by Grigoriy Shilyaev on 08.10.23.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.images, id: \.id) { image in
                    if let imageURL = URL(string: image.url) {
                        NavigationLink(destination: DetailView(viewModel: DetailViewModel(image: image))) {
                            if let uiImage = viewModel.imageDictionary[image.url] {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(CGFloat(image.width) / CGFloat(image.height), contentMode: .fit)
                            } else {
                                ProgressView()
                                    .onAppear {
                                        viewModel.cacheImage(for: imageURL)
                                    }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * (CGFloat(image.height) / CGFloat(image.width)))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .onAppear {
                            if self.viewModel.images.last == image && !self.viewModel.isLoading && !self.viewModel.images.isEmpty {
                                viewModel.loadImages()
                            }
                        }
                    }
                }
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
        .onAppear {
            if viewModel.images.isEmpty {
                viewModel.loadImages()
            }
        }
    }
}
