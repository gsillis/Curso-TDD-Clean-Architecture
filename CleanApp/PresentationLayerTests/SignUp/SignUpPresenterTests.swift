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
    
    func test_signUp_should_call_validation_with_correct_values() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validation: validationSpy)
        let viewModel = makeSignUpViewModel()
        sut.signUp(viewModel: viewModel)
        XCTAssertTrue(NSDictionary(dictionary: validationSpy.data!).isEqual(to: viewModel.toJson()!))
    }
}

extension SignUpPresenterTests {
    func makeSut(alerView: AlertViewSpy = AlertViewSpy(),
                 addAccount: AddAccountSpy = AddAccountSpy(),
                 loadingView: LoadingViewSpy = LoadingViewSpy(),
                 validation: Validation = ValidationSpy(),
                 file: StaticString = #file,
                 line: UInt = #line) -> SignUpPresenter {
        let sut = SignUpPresenter(alertView: alerView,
                                  addAccount: addAccount,
                                  loadingView: loadingView,
                                  validation: validation)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
