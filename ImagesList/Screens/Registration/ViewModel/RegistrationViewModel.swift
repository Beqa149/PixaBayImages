//
//  RegistrationViewModel.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import Foundation
import RxSwift
import RxCocoa

class RegistrationViewModel: ObservableObject {
    let email = BehaviorRelay<String>(value: "")
    let age = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let repeatPassword = BehaviorRelay<String>(value: "")
    
    let emailErrorMessage = BehaviorRelay<String>(value: "")
    let ageErrorMessage = BehaviorRelay<String>(value: "")
    let passwordErrorMessage = BehaviorRelay<String>(value: "")
    
    let authService: AuthServiceProtocol
    let disposeBag = DisposeBag()
    
    var isSignUpEnabled: Observable<Bool> {
            return Observable.combineLatest(email.asObservable(), password.asObservable(), repeatPassword.asObservable()) { email, password, repeatPassword in
                return !email.isEmpty && !password.isEmpty && password == repeatPassword
            }
        }
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
        
        email.asObservable()
                    .map { self.validateEmail($0) }
                    .bind(to: emailErrorMessage)
                    .disposed(by: disposeBag)
        
        age.asObservable()
                    .map { self.validateAge($0) }
                    .bind(to: ageErrorMessage)
                    .disposed(by: disposeBag)
        
        password.asObservable()
                    .map { self.validatePassword($0) }
                    .bind(to: passwordErrorMessage)
                    .disposed(by: disposeBag)
    }
    
    func signUp() -> Observable<Bool> {
        return authService.signUp(email: email.value, age: age.value, password: password.value)
        }
    
    func validate() -> Observable<Bool> {
        return Observable.combineLatest(email.asObservable(), age.asObservable(), password.asObservable())
            .map { email, age, password in
                !email.isEmpty && age.isEmpty && !password.isEmpty
            }
    }
    
    private func validateEmail(_ email: String) -> String {
        if email.isEmpty {
                    return ""
            }
        let emailRegEx = "(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,}"

            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email) ? "" : "Invalid email address"
        }
    
    private func validateAge(_ age: String) -> String {
        if age.isEmpty {
            return ""
        } else {
            if let age = Int(age) {
                return age > 17 && age < 100 ? "" : "Age must be minimum 18 and maximum 99"
            } else {
                return "invalid number"
            }
        }
        
    }
    
    private func validatePassword(_ password: String) -> String {
        if password.isEmpty {
                    return ""
        }
        
        return password.count > 5 && password.count < 13 ? "" : "password must be at least 6 and at most 12 characters long"
    }
}
