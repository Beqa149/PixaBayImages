//
//  Coordinator.swift
//  ImagesList
//
//  Created by Beqa Baramia on 11.07.24.
//

import Foundation
enum AppRoute {
    case auth
    case itemList
}

class AppCoordinator: ObservableObject {
    static let shared = AppCoordinator()
    
    @Published var currentView: AppRoute = .auth

    private init() {}

    func navigate(to route: AppRoute) {
        currentView = route
    }
}
