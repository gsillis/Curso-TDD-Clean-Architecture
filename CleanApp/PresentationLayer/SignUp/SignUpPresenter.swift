//
//  SignUpPresenter.swift
//  PresentationLayer
//
//  Created by Gabriela Sillis on 08/03/22.
//

import Foundation
import Domain

public final class SignUpPresenter {
    private let alertView: AlertView
    private let addAccount: AddAccount
    private let loadingView: LoadingView
    private let validation: Validation
    
    public init(
        alertView: AlertView,
        addAccount: AddAccount,
        loadingView: LoadingView,
        validation: Validation) {
        self.alertView = alertView
        self.addAccount = addAccount
        self.loadingView = loadingView
        self.validation = validation
    }
    
    public func signUp(viewModel: SignUpViewModel) {
        if let message = validation.validate(data: viewModel.toJson()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: message))
        } else {
            loadingView.show(viewModel: LoadingViewModel(isLoading: true))
            addAccount.add(addAccountModel: viewModel.toAddAccountModel(viewModel: viewModel)) { [weak self] result in
                guard let self = self else { return }
                self.loadingView.show(viewModel: LoadingViewModel(isLoading: false))
                switch result {
                case.failure(let error):
                    self.getError(error)
                case .success:
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Tudo certo", message: "Conta criada com sucesso"))
                }
            }
        }
    }
    
    private func getError(_ error: DomainError) {
        var errorMessage: String?
        switch error {
        case .emailInUse:
            errorMessage = "Esse email já está em uso"
        default:
            errorMessage = "Algo inesperado aconteceu, tente novamente mais tarde"
        }
        alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: errorMessage))
    }
}
