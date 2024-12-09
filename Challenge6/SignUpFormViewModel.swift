//
//  SignUpFormViewModel.swift
//  Challenge6
//
//  Created by Nguyễn Đức Hậu on 09/12/2024.
//

import Foundation
import Combine

enum PasswordCheck {
    case invalidLength
    case noMatch
    case valid
}

class SignUpFormViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    
    @Published var usernameMessage: String = ""
    @Published var passwordMessage: String = ""
    @Published var valid: Bool = false
    
    private var cancelableset: Set<AnyCancellable> = []
    
    init() {
        usernameValidPublisher
            .receive(on: RunLoop.main)
            .map { $0 ? "" : "Username too short. Needs to be at least 3 characters"}
            .assign(to: \.usernameMessage, on: self)
            .store(in: &cancelableset)
        
        passwordValidPublisher
            .receive(on: RunLoop.main)
            .map { passwordCheck in
                switch(passwordCheck) {
                case .invalidLength:
                    return "Passwords must not be empty"
                case .noMatch:
                    return "Passwords do not match"
                default:
                    return ""
                }
            }
            .assign(to: \.passwordMessage, on: self)
            .store(in: &cancelableset)
        
        formIsValidPublisher
            .receive(on: RunLoop.main)
            .map {
                $0 ? true : false
            }
            .assign(to: \.valid, on: self)
            .store(in: &cancelableset)
    }
}
extension SignUpFormViewModel {
    var usernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .removeDuplicates()
            .map { $0.count >= 3 }
            .eraseToAnyPublisher()
    }
    
    var passwordLengthValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .removeDuplicates()
            .map { $0.count > 0}
            .eraseToAnyPublisher()
    }
    
    var passwordMatchValidPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .CombineLatest($password, $passwordConfirmation)
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { password, passwordConfirmation in
                password == passwordConfirmation
            }
            .eraseToAnyPublisher()
    }
    
    var passwordValidPublisher: AnyPublisher<PasswordCheck, Never> {
        Publishers
            .CombineLatest(passwordLengthValidPublisher, passwordMatchValidPublisher)
            .map { validLength, matching in
                if !validLength {
                    return .invalidLength
                }
                if !matching {
                    return .noMatch
                }
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    var formIsValidPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .CombineLatest(usernameValidPublisher, passwordValidPublisher)
            .map { userIsValid, passIsValid in
                userIsValid && passIsValid == .valid
            }
            .eraseToAnyPublisher()
    }
}
