//
//  SignUpPresenterTests.swift
//  SignUpPresenterTests
//
//  Created by Gabriela Sillis on 06/03/22.
//

import XCTest

class SignUpPresenter {
    private let alertView: AlertView
    
    init(alertView: AlertView) {
        self.alertView = alertView
    }
    
    func signUp(viewModel: SignUpViewModel) {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            let viewModel = AlertViewModel(title: "Erro", message: "O campo Nome é obrigatório")
            alertView.showMessage(viewModel: viewModel)
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            let viewModel = AlertViewModel(title: "Erro", message: "O campo Email é obrigatório")
            alertView.showMessage(viewModel: viewModel)
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            let viewModel = AlertViewModel(title: "Erro", message: "O campo Senha é obrigatório")
            alertView.showMessage(viewModel: viewModel)
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            let viewModel = AlertViewModel(title: "Erro", message: "O campo Confirmar Senha é obrigatório")
            alertView.showMessage(viewModel: viewModel)
        }
    }
}

struct SignUpViewModel {
    var name: String?
    var email: String?
    var password: String?
    var passwordConfirmation: String?
}

protocol AlertView {
    func showMessage(viewModel: AlertViewModel)
}

struct AlertViewModel: Equatable {
    var title: String?
    var message: String?
}

class SignUpPresenterTests: XCTestCase {

    func test_signUp_should_show_error_message_if_name_is_not_provided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(
            email: "any_email",
            password: "any_password",
            passwordConfirmation: "any_password"
        )
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(
            title: "Erro",
            message: "O campo Nome é obrigatório")
        )
    }
    
    func test_signUp_should_show_error_message_if_email_is_not_provided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(
            name: "any_name",
            password: "any_password",
            passwordConfirmation: "any_password"
        )
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(
            title: "Erro",
            message: "O campo Email é obrigatório")
        )
    }
    
    func test_signUp_should_show_error_message_if_password_is_not_provided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(
            name: "any_name",
            email: "any_email",
            passwordConfirmation: "any_password"
        )
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(
            title: "Erro",
            message: "O campo Senha é obrigatório")
        )
    }
    
    func test_signUp_should_show_error_message_if_password_confirmation_is_not_provided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(
            name: "any_name",
            email: "any_email",
            password: "any_password"
        )
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(
            title: "Erro",
            message: "O campo Confirmar Senha é obrigatório")
        )
    }
}

extension SignUpPresenterTests {
    func makeSut() -> (sut: SignUpPresenter, alerViewSpy: AlertViewSpy) {
        let alertViewSpy = AlertViewSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy)
        return (sut, alertViewSpy)
    }
    
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
