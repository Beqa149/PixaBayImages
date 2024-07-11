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

class LoginViewModel: ObservableObject {
    
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let isLoginEnabled: Observable<Bool>
    let errorMessage = PublishSubject<String>()

    private let authService: AuthServiceProtocol
    private let disposeBag = DisposeBag()

    init(authService: AuthServiceProtocol) {
        self.authService = authService

        isLoginEnabled = Observable.combineLatest(email.asObservable(), password.asObservable())
            .map { email, password in
                // Add your validation logic here
                return !email.isEmpty && !password.isEmpty && password.count >= 6 && password.count <= 12
            }
    }

//    func login() {
//        authService.signIn(with: Credentials(email: email.value, password: "asdasdas"), completion: )
//            .subscribe(onNext: { success in
//                if success {
//                    // Navigate to the main page
//                } else {
//                    self.errorMessage.onNext("Login failed")
//                }
//            })
//            .disposed(by: disposeBag)
//    }
}

//error: Filename "LogInViewModel.swift" used twice: 
//'/Users/beqabaramia/Desktop/ImagesList/ImagesList/Screens/LogIn/ViewModel/LogInViewModel.swift' and
//'/Users/beqabaramia/Desktop/ImagesList/ImagesList/Screens/ItemDetail/ViewModel/LogInViewModel.swift' (in target 'ImagesList' from project 'ImagesList')
