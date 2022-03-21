//
//  SignUpPresenterTests.swift
//  SignUpPresenterTests
//
//  Created by Gabriela Sillis on 06/03/22.
//

import XCTest
import PresentationLayer

class SignUpPresenterTests: XCTestCase {
    
    func test_signUp_should_show_error_message_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alerView: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(name: nil))
        
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModel(message: "O campo Nome é obrigatório"))
    }
    
    func test_signUp_should_show_error_message_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alerView: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(email: nil))
        
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModel(message: "O campo Email é obrigatório"))
    }
    
    func test_signUp_should_show_error_message_if_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alerView: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(password: nil))
        
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModel(message: "O campo Senha é obrigatório"))
    }
    
    func test_signUp_should_show_error_message_if_password_confirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alerView: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModel(message: "O campo Confirmar Senha é obrigatório"))
    }
    
    func test_signUp_should_show_error_message_if_password_confirmation_not_match() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alerView: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "wrong_password"))
        
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModel(message: "As senhas não são iguais"))
    }
    
    func test_signUp_should_call_emailValidator_with_correct_email() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(alerView: alertViewSpy, emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
    
    func test_signUp_should_show_error_message_if_invalid_email_is_provided() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(alerView: alertViewSpy, emailValidator: emailValidatorSpy)
        emailValidatorSpy.isValid = false
        sut.signUp(viewModel: makeSignUpViewModel())
        
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModel(message: "O email é inválido"))
    }
}

extension SignUpPresenterTests {
    func makeSut(alerView: AlertViewSpy = AlertViewSpy(),
                 emailValidator: EmailValidatorSpy = EmailValidatorSpy()) -> SignUpPresenter{
        let sut = SignUpPresenter(alertView: alerView, emailValidator: emailValidator)
        return sut
    }
    
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
        return AlertViewModel(
            title: "Erro",
            message:  message
        )
    }
    
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
    
    class EmailValidatorSpy: EmailValidator {
        var isValid: Bool = true
        var email: String?
        
        func isValid(email: String) -> Bool {
            self.email = email
            return isValid
        }
    }
}
