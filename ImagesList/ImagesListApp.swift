//
//  ImagesListApp.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import SwiftUI

@main
struct ImagesListApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let container = ServiceContainer.shared
        container.register(type: AuthServiceProtocol.self, service: MockAuthService())
        container.register(type: ImagesServiceProtocol.self, service: ImagesService())
        
        return true
    }
}
