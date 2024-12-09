//
//  SignUpFormView.swift
//  Challenge6
//
//  Created by Nguyễn Đức Hậu on 09/12/2024.
//

import SwiftUI
import Combine

struct SignUpFormView: View {
    @ObservedObject private var signUpFormViewModel = SignUpFormViewModel()
    var body: some View {
        NavigationView {
            Form {
                //Username
                Section {
                    TextField("Username", text: $signUpFormViewModel.username)
                    if signUpFormViewModel.usernameMessage == "Username too short. Needs to be at least 3 characters"{
                        Text("\(signUpFormViewModel.usernameMessage)")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }                }
                
                //Password
                Section {
                    TextField("Password", text: $signUpFormViewModel.password)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    SecureField("Repeat Password", text: $signUpFormViewModel.passwordConfirmation)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    if signUpFormViewModel.passwordMessage == "Passwords must not be empty"
                        || signUpFormViewModel.passwordMessage == "Passwords do not match"
                    {
                        Text("\(signUpFormViewModel.passwordMessage)")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                //Sign up
                Section {
                    Button("Sign up") {
                    }
                    .disabled(!signUpFormViewModel.valid)
                    
                }
            }
            .navigationTitle("Sign up")
        }
    }
}

#Preview {
    SignUpFormView()
}
