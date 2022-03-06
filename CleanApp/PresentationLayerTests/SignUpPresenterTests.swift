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

    func test_sign_up() {
        let alertViewSpy = AlertViewSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy)
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
}

extension SignUpPresenterTests {
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
