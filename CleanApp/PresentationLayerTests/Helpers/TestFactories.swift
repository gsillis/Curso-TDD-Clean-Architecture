//
//  TestFactories.swift
//  PresentationLayerTests
//
//  Created by Gabriela Sillis on 30/03/22.
//

import Foundation
import PresentationLayer

func makeSignUpViewModel(name: String? = "any_name",
                         email: String? = "any_email",
                         password: String? = "any_password",
                         passwordConfirmation: String? = "any_password") -> SignUpViewModel {
    return SignUpViewModel(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation
    )
}

func makeAlertViewModel(message: String) -> AlertViewModel {
    return AlertViewModel(title: "Erro", message:  message)
}

func makeSuccessAlertViewModel(message: String) -> AlertViewModel {
    return AlertViewModel(title: "Tudo certo", message: message)
}

func makeLoginViewModel(email: String? = "any_email",
                        password: String? = "any_password") -> LoginViewModel {
    return LoginViewModel(
        email: email,
        password: password
    )
}
