//
//  LitresApp.swift
//  Litres
//
//  Created by Grigoriy Shilyaev on 08.10.23.
//

import SwiftUI

@main
struct LitresApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView(viewModel: MainViewModel.init(networkService: NetworkManager.init()))
            }
        }
    }
}
