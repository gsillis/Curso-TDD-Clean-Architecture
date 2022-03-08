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
        let (sut, alertViewSpy, _) = makeSut()
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
        let (sut, alertViewSpy, _) = makeSut()
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
        let (sut, alertViewSpy, _) = makeSut()
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
            let (sut, alertViewSpy, _) = makeSut()
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
    
    func test_signUp_should_show_error_message_if_password_confirmation_not_match() {
        let (sut, alertViewSpy, _) = makeSut()
        let signUpViewModel = SignUpViewModel(
            name: "any_name",
            email: "any_email",
            password: "any_password",
            passwordConfirmation: "wrong_password"
        )
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(
            title: "Erro",
            message:  "As senhas não são iguais")
        )
    }
    
    func test_signUp_should_call_emailValidator_with_correct_email() {
        let (sut, _, emailValidatorSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(
            name: "any_name",
            email: "email@mail.com",
            password: "any_password",
            passwordConfirmation: "any_password"
        )
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
    
    func test_signUp_should_show_error_message_if_invalid_email_is_provided() {
        let (sut, alertViewSpy, emailValidator) = makeSut()
        let signUpViewModel = SignUpViewModel(
            name: "any_name",
            email: "any_email",
            password: "any_password",
            passwordConfirmation: "any_password"
        )
        emailValidator.isValid = false
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(
            title: "Erro",
            message:  "O email é inválido")
        )
    }
}

extension SignUpPresenterTests {
    func makeSut() -> (sut: SignUpPresenter, alerViewSpy: AlertViewSpy, emailValidator: EmailValidatorSpy) {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        return (sut, alertViewSpy, emailValidatorSpy)
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
