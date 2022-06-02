//
//  LoginComposerTests.swift
//  MainTests
//
//  Created by Gabriela Sillis on 01/06/22.
//

import XCTest
import Main
import UI
import Validation
import PresentationLayer

class LoginComposerTests: XCTestCase {
    func test_login_should_compose_with_correct_validations() {
        let validations = LoginComposer.makeLoginValidations()
        XCTAssertEqual(validations[0] as! RequiredFieldValidation, RequiredFieldValidation(
            fieldName: "email",
            fieldLabel: "Email"
        ))
        XCTAssertEqual(validations[1] as! EmailVadation, EmailVadation(
            fieldName: "email",
            fieldLabel: "Email",
            emailValidator: EmailValidatorSpy()
        ))
        XCTAssertEqual(validations[2] as! RequiredFieldValidation, RequiredFieldValidation(
            fieldName: "password",
            fieldLabel: "Password"
        ))
    }
    
    func test_login_background_request_should_complete_on_main_thread()  {
        let (sut, addAccount) = makeSut()
        sut.loadViewIfNeeded()
        sut.login?(makeLoginViewModel())
        let exp = expectation(description: "waiting")
        DispatchQueue.global().async {
            addAccount.completeWithError(.unexpectedError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

extension LoginComposerTests {
    func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: LoginViewController, authenticationSpy: AuthenticationSpy) {
        let authentication = AuthenticationSpy()
        let sut = LoginComposer.makeLoginViewController(authentication: MainQueueDispatchDecorator(authentication))
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: authentication, file: file, line: line)
        return (sut, authentication)
    }
}
