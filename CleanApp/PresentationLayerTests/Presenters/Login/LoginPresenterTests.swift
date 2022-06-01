//
//  LoginPresenterTests.swift
//  PresentationLayerTests
//
//  Created by Gabriela Sillis on 31/05/22.
//

import XCTest
import PresentationLayer
import Domain

class LoginPresenterTests: XCTestCase {
    func test_login_should_call_validation_with_correct_values() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validation: validationSpy)
        let viewModel = makeLoginViewModel()
        sut.login(viewModel: viewModel)
        XCTAssertTrue(NSDictionary(dictionary: validationSpy.data!).isEqual(viewModel.toJson()!))
    }
    
    func test_login_should_shows_error_message_if_validation_fails() {
        let alertViewSpy = AlertViewSpy()
        let validationSpy = ValidationSpy()
        let sut = makeSut(validation: validationSpy, alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Falha na validação", message: "Erro"))
            exp.fulfill()
        }
        validationSpy.simulateError()
        sut.login(viewModel: makeLoginViewModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_should_call_authentication_with_correct_values() {
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(authentication: authenticationSpy)
        sut.login(viewModel: makeLoginViewModel())
        XCTAssertEqual(authenticationSpy.authenticationModel, makeAuthenticationModel())
    }
    
    func test_login_should_shows_error_message_if_authentication_fails() {
        let alertViewSpy = AlertViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(alertView: alertViewSpy, authentication: authenticationSpy)
        let exp = expectation(description: "waiting")
        
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "Algo inesperado aconteceu, tente novamente mais tarde"))
            exp.fulfill()
        }
        
        sut.login(viewModel: makeLoginViewModel())
        authenticationSpy.completeWithError(.unexpectedError)
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_should_shows_expired_session_if_authentication_completes_with_expired_session() {
        let alertViewSpy = AlertViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(alertView: alertViewSpy, authentication: authenticationSpy)
        let exp = expectation(description: "waiting")
        
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewModel(message: "Email e/ou senha inválido(s)"))
            exp.fulfill()
        }
        
        sut.login(viewModel: makeLoginViewModel())
        authenticationSpy.completeWithError(.sessionExpired)
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_should_shows_success_message_if_authentication_succeeds() {
        let alertViewSpy = AlertViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(alertView: alertViewSpy, authentication: authenticationSpy)
        let exp = expectation(description: "waiting")
        
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, makeSuccessAlertViewModel(message: "Login realizado com sucesso"))
            exp.fulfill()
        }
        
        sut.login(viewModel: makeLoginViewModel())
        authenticationSpy.completeWithAccount(makeAccountModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_should_shows_loading_before_and_after_authentication() {
        let loadingViewSpy = LoadingViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(authentication: authenticationSpy, loadingView: loadingViewSpy)
        let exp = expectation(description: "waiting")

        loadingViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            exp.fulfill()
        }
        
        sut.login(viewModel: makeLoginViewModel())
        wait(for: [exp], timeout: 1)
        
        let expTwo = expectation(description: "waiting")
        
        loadingViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            expTwo.fulfill()
        }
        authenticationSpy.completeWithError(.unexpectedError)
        wait(for: [expTwo], timeout: 1)
    }
}

extension LoginPresenterTests {
    func makeSut(validation: Validation = ValidationSpy(),
                 alertView: AlertView = AlertViewSpy(),
                 authentication: Authentication = AuthenticationSpy(),
                 loadingView: LoadingView = LoadingViewSpy(),
                 file: StaticString = #file,
                 line: UInt = #line) -> LoginPresenter {
        let sut = LoginPresenter(validation: validation, alertView: alertView, authentication: authentication, loadingView: loadingView)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
