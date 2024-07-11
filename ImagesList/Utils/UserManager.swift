//
//  UserManager.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    
    var isUserLoggedIn: Bool {
        get {
            let userDefaults = UserDefaults.standard
            return userDefaults.bool(forKey: "isUserLoggedIn")
        }
    }
    
    private init() {}
    
    func storeUser(_ user: User) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: user.email)
        } catch {
            print("Failed to encode user: \(error)")
        }
    }
    
    func retrieveUser(by email: String) -> User? {
        if let data = UserDefaults.standard.data(forKey: email) {
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                return user
            } catch {
                print("Failed to decode user: \(error)")
            }
        }
        return nil
    }
}
