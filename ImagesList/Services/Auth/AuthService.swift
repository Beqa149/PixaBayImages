//
//  AuthService.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import Foundation
import RxSwift

protocol AuthServiceProtocol {
    func signIn(email: String, password: String) -> Observable<Bool>
    func signUp(email: String, age: String, password: String) -> Observable<Bool>
}

class MockAuthService: AuthServiceProtocol {
    private var registeredUsers: [User] = []

    func signIn(email: String, password: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let user = UserManager.shared.retrieveUser(by: email)
            observer.onNext(user != nil)
            observer.onCompleted()
            return Disposables.create()
        }
    }

    func signUp(email: String, age: String, password: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let user = UserManager.shared.retrieveUser(by: email)
            if user != nil {
                observer.onNext(false)
            } else {
                let newUser = User(email: email, password: password, age: age)
                UserManager.shared.storeUser(newUser)
                observer.onNext(true)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

struct Credentials {
    let email: String
    let password: String
}

struct User: Codable {
    let email: String
    let password: String
    let age: String
}

enum AuthenticationError: Error {
    case invalidCredentials
    case networkError
    case usernameTaken
    case invalidEmail
}
