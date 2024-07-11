//
//  AuthViewModel.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import Foundation
import RxSwift
import RxCocoa

class AuthViewModel: ObservableObject {
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    
    func signIn() -> Observable<Bool> {
        
        return Observable.just(true)
    }
    
    func signUp() -> Observable<Bool> {
        
        return Observable.just(true)
    }
}

