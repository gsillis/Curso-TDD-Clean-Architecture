//
//  LoginPresenter.swift
//  PresentationLayer
//
//  Created by Gabriela Sillis on 31/05/22.
//

import Foundation
import Domain

public final class LoginPresenter {
    private var validation: Validation
    private var alertView: AlertView
    private var authentication: Authentication
    
    public init(validation: Validation, alertView: AlertView, authentication: Authentication) {
        self.validation = validation
        self.alertView = alertView
        self.authentication = authentication
    }
    
    public func login(viewModel: LoginViewModel) {
        if let message = validation.validate(data: viewModel.toJson()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            authentication.auth(authenticationModel: viewModel.toAuthenticationModel()) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case.failure(let error):
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: "Algo inesperado aconteceu, tente novamente mais tarde"))
                case .success:
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Tudo certo", message: "Conta criada com sucesso"))
                }
            }
        }
    }
}
