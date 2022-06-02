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
    private var loadingView: LoadingView
    
    public init(validation: Validation, alertView: AlertView, authentication: Authentication, loadingView: LoadingView) {
        self.validation = validation
        self.alertView = alertView
        self.authentication = authentication
        self.loadingView = loadingView
    }
    
    public func login(viewModel: LoginViewModel) {
        if let message = validation.validate(data: viewModel.toJson()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            loadingView.show(viewModel: LoadingViewModel(isLoading: true))
            authentication.auth(authenticationModel: viewModel.toAuthenticationModel()) { [weak self] result in
                guard let self = self else { return }
                self.loadingView.show(viewModel: LoadingViewModel(isLoading: false))
                switch result {
                case.failure(let error):
                    self.getError(error)
                case .success:
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Tudo certo", message: "Login realizado com sucesso"))
                }
            }
        }
    }
    
    private func getError(_ error: DomainError) {
        var errorMessage: String?
        switch error {
        case .sessionExpired:
            errorMessage = "Email e/ou senha inválido(s)"
        default:
            errorMessage = "Algo inesperado aconteceu, tente novamente mais tarde"
        }
        alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: errorMessage))
    }
}
