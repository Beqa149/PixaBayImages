//
//  LogInView.swift
//  ImagesList
//
//  Created by Beqa Baramia on 08.07.24.
//

import SwiftUI
import RxSwift
import RxRelay

struct LoginView: View {
   
    @State var viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    @State private var isSignInSuccessful: Bool = false
    @State private var showAlert: Bool = false
    @State private var navigateToItemList = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Email", text: relayBinding(for: viewModel.email))
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .padding(.bottom, 2)
            if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
            
                    SecureField("Password", text: relayBinding(for: viewModel.password))
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .padding(.bottom, 20)
            
            Button(
                action: {
                    viewModel.signIn()
                                        .observe(on: MainScheduler.instance)
                                        .subscribe(onNext: { success in
                                            self.isSignInSuccessful = success
                                            let userDefaults = UserDefaults.standard
                                            userDefaults.set(success, forKey: "isUserLoggedIn")
                                        })
                                        .disposed(by: disposeBag)
                }, label: {
                    Text("Login")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            )
        }
        .padding()
        .onAppear {
            viewModel.errorMessage
                            .asObservable()
                            .subscribe(onNext: { message in
                                self.errorMessage = message
                            })
                            .disposed(by: disposeBag)
            }
        .fullScreenCover(isPresented: $isSignInSuccessful) {
            let imagesService = ServiceContainer.shared.resolve(type: ImagesServiceProtocol.self)!
            let viewModel = ImageListViewModel(service: imagesService)
            ImageListView(viewModel: viewModel)
        }
    }
}

func relayBinding(for relay: BehaviorRelay<String>) -> Binding<String> {
        Binding(
            get: { relay.value },
            set: { relay.accept($0) }
        )
}
