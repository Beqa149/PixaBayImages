//
//  RegistrationView.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import SwiftUI
import RxSwift
import RxCocoa

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel(authService: MockAuthService())
    @State private var isValid = false
    @State private var isSignUpSuccessful: Bool = false
    @State private var showAlert: Bool = false
    
    @State private var emailErrorMessage: String = ""
    @State private var ageErrorMessage: String = ""
    @State private var passwordErrorMessage: String = ""
    
    private let disposeBag = DisposeBag()
    
    var body: some View {
        VStack(alignment: .leading){
            
            TextField("Email", text: relayBinding(for: viewModel.email))
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
            if !emailErrorMessage.isEmpty {
                            Text(emailErrorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
            
            TextField("Age", text: relayBinding(for: viewModel.age))
                        .autocapitalization(.none)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
            
            if !ageErrorMessage.isEmpty {
                Text(ageErrorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
                
            SecureField("Password", text: relayBinding(for: viewModel.password))
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                
                if !passwordErrorMessage.isEmpty {
                    Text(passwordErrorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            
            Button(
                action: {
                    viewModel.signUp()
                            .observe(on: MainScheduler.instance)
                            .subscribe(onNext: { success in
                                self.isSignUpSuccessful = success
                                let userDefaults = UserDefaults.standard
                                userDefaults.set(success, forKey: "isUserLoggedIn")
                                
                            })
                            .disposed(by: disposeBag)
                }, label: {
                    Text("Register")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .foregroundColor(Color.white)
                        .disabled(!isValid)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            )
            
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.emailErrorMessage
                            .asObservable()
                            .subscribe(onNext: { message in
                                self.emailErrorMessage = message
                            })
                            .disposed(by: disposeBag)
            
            viewModel.ageErrorMessage
                            .asObservable()
                            .subscribe(onNext: { message in
                                self.ageErrorMessage = message
                            })
                            .disposed(by: disposeBag)
            
            viewModel.passwordErrorMessage
                            .asObservable()
                            .subscribe(onNext: { message in
                                self.passwordErrorMessage = message
                            })
                            .disposed(by: disposeBag)
        }
        .fullScreenCover(isPresented: $isSignUpSuccessful) {
            let imagesService = ServiceContainer.shared.resolve(type: ImagesServiceProtocol.self)!
            let viewModel = ImageListViewModel(service: imagesService)
            ImageListView(viewModel: viewModel)
        }
    }
}
