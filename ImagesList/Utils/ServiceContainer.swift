//
//  ServiceContainer.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import Foundation

class ServiceContainer {
    static let shared = ServiceContainer()
    
    private init() {}
    
    var services: [String: Any] = [:]
    
    func register<Service>(type: Service.Type, service: Any) {
          services["\(type)"] = service
      }

    func resolve<Service>(type: Service.Type) -> Service? {
        return services["\(type)"] as? Service
      }
}
