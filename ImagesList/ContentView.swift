//
//  ContentView.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var coordinator = AppCoordinator.shared
    
    var body: some View {
        
        VStack {
            switch coordinator.currentView {
            case .auth:
                AuthView()
            case .itemList:
                let imagesService = ServiceContainer.shared.resolve(type: ImagesServiceProtocol.self)!
                let viewModel = ImageListViewModel(service: imagesService)
                ImageListView(viewModel: viewModel)
            }
            }.onAppear {
                if UserManager.shared.isUserLoggedIn {
                    coordinator.navigate(to: .itemList)
            }
        }
    }
}
