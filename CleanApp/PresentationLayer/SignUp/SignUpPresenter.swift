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
    private let emailValidator: EmailValidator
    private let addAccount: AddAccount
    private let loadingView: LoadingView
    
    public init(alertView: AlertView, emailValidator: EmailValidator, addAccount: AddAccount, loadingView: LoadingView) {
        self.alertView = alertView
        self.emailValidator = emailValidator
        self.addAccount = addAccount
        self.loadingView = loadingView
    }
    
    public func signUp(viewModel: SignUpViewModel) {
        if let message = validateFields(viewModel: viewModel) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: message))
        } else {
            loadingView.show(viewModel: LoadingViewModel(isLoading: true))
            addAccount.add(addAccountModel: SignUpMapper.toAddAccountModel(viewModel: viewModel)) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case.failure:
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: "Algo inesperado aconteceu, tente novamente mais tarde"))
                case .success:
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Tudo certo", message: "Conta criada com sucesso"))
                }
                self.loadingView.show(viewModel: LoadingViewModel(isLoading: false))
            }
        }
    }
    
    private func validateFields(viewModel: SignUpViewModel) -> String? {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            return "O campo Nome é obrigatório"
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "O campo Email é obrigatório"
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "O campo Senha é obrigatório"
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return "O campo Confirmar Senha é obrigatório"
        } else if viewModel.password != viewModel.passwordConfirmation {
            return "As senhas não são iguais"
        } else if !emailValidator.isValid(email: viewModel.email ?? "") {
            return "O email é inválido"
        }
        
        return nil
    }
}
