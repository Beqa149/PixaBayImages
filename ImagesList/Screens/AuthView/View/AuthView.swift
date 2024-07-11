//
//  AuthView.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import SwiftUI
import RxSwift
import RxCocoa

struct AuthView: View {
    
    @State private var isSignIn = true
    
    private let disposeBag = DisposeBag()
    
    var body: some View {
        VStack {
            Text(isSignIn ? "Sign In" : "Sign Up")
                .font(.largeTitle)
                .padding()

            if isSignIn {
                let service = ServiceContainer.shared.resolve(type: AuthServiceProtocol.self)!
                let viewModel = LoginViewModel(authService: service)
                LoginView(viewModel: viewModel)
            } else {
                RegistrationView()
            }
            
            Spacer()
            
            Button(action: {
                isSignIn.toggle()
            }) {
                Text(isSignIn ? "Don't have an account? Sign Up" : "Already have an account? Sign In")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
    }
}
