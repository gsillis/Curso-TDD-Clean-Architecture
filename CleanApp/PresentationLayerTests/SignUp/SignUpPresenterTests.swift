//
//  SignUpPresenterTests.swift
//  SignUpPresenterTests
//
//  Created by Gabriela Sillis on 06/03/22.
//

import XCTest
import PresentationLayer
import Domain

class SignUpPresenterTests: XCTestCase {
    
    func test_signUp_should_show_error_message_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alerView: alertViewSpy)
        let exp = expectation(description: "waiting")
        
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "O campo Nome é obrigatório"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(name: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alerView: alertViewSpy)
        let exp = expectation(description: "witing")
        
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "O campo Email é obrigatório"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(email: nil))
        wait(for: [exp], timeout: 1)
        
    }
    
    func test_signUp_should_show_error_message_if_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alerView: alertViewSpy)
        let exp = expectation(description: "waiting")
        
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "O campo Senha é obrigatório"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel(password: nil))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_password_confirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alerView: alertViewSpy)
        let exp = expectation(description: "waiting")
        
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "O campo Confirmar Senha é obrigatório"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_password_confirmation_not_match() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alerView: alertViewSpy)
        let exp = expectation(description: "waiting")
        
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "As senhas não são iguais"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "wrong_password"))
        wait(for: [exp], timeout: 1)
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
        let exp = expectation(description: "waiting")
        emailValidatorSpy.isValid = false
        
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "O email é inválido"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_call_addAccount_with_correct_values() {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccount: addAccountSpy)
        sut.signUp(viewModel: makeSignUpViewModel())
        
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
    }
    
    func test_signUp_should_shows_error_message_if_addAccount_fails() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alerView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "Algo inesperado aconteceu, tente novamente mais tarde"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completeWithError(.unexpectedError)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_shows_success_message_if_addAccount_succeeds() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alerView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeSuccessAlertViewModel(message: "Conta criada com sucesso"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completeWithAccount(makeAccountModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_shows_loading_before_and_after_addAccount() {
        let loadingViewSpy = LoadingViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccount: addAccountSpy, loadingView: loadingViewSpy)
        let exp = expectation(description: "waiting")

        loadingViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel())
        wait(for: [exp], timeout: 1)
        
        let expTwo = expectation(description: "waiting")
        
        loadingViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            expTwo.fulfill()
        }
        addAccountSpy.completeWithError(.unexpectedError)
        wait(for: [expTwo], timeout: 1)
    }
}

extension SignUpPresenterTests {
    func makeSut(alerView: AlertViewSpy = AlertViewSpy(),
                 emailValidator: EmailValidatorSpy = EmailValidatorSpy(),
                 addAccount: AddAccountSpy = AddAccountSpy(),
                 loadingView: LoadingViewSpy = LoadingViewSpy(),
                 file: StaticString = #file,
                 line: UInt = #line) -> SignUpPresenter {
        let sut = SignUpPresenter(alertView: alerView,
                                  emailValidator: emailValidator,
                                  addAccount: addAccount,
                                  loadingView: loadingView)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
