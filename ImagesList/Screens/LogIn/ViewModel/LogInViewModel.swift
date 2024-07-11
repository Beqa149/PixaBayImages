//
//  LogInViewModel.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftUI
import RxRelay

//class LoginViewModel: ObservableObject {
//    
//    let email = BehaviorRelay<String>(value: "")
//    let password = BehaviorRelay<String>(value: "")
//    let isLoginEnabled: Observable<Bool>
//    let errorMessage = PublishSubject<String>()
//
//    private let authService: AuthServiceProtocol
//    private let disposeBag = DisposeBag()
//
//    init(authService: AuthServiceProtocol) {
//        self.authService = authService
//
//        isLoginEnabled = Observable.combineLatest(email.asObservable(), password.asObservable())
//            .map { email, password in
//                // Add your validation logic here
//                return !email.isEmpty && !password.isEmpty && password.count >= 6 && password.count <= 12
//            }
//    }
//}

class LoginViewModel {
    
    let authService: AuthServiceProtocol
    
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let disposeBag = DisposeBag()
    
    let errorMessage = BehaviorRelay<String>(value: "")
    
    var isSignInEnabled: Observable<Bool> {
        return Observable.combineLatest(email.asObservable(), password.asObservable()) { email, password in
            return !email.isEmpty && !password.isEmpty
        }
    }

    init(authService: AuthServiceProtocol) {
        self.authService = authService
        email.asObservable()
                    .map { self.validateEmail($0) }
                    .bind(to: errorMessage)
                    .disposed(by: disposeBag)
    }

    func signIn() -> Observable<Bool> {
        return authService.signIn(email: email.value, password: password.value)
    }
    
    private func validateEmail(_ email: String) -> String {
        if email.isEmpty {
                    return ""
            }
        let emailRegEx = "(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,}"

            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email) ? "" : "Invalid email address"
        }
}
