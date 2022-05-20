//
//  SignUpIntegrationTests.swift
//  MainTests
//
//  Created by Gabriela Sillis on 12/04/22.
//

import XCTest
import Main
import UI
import Validation

class SignUpComposerTests: XCTestCase {
    func test_background_request_should_complete_on_main_thread()  {
        let (sut, addAccount) = makeSut()
        sut.loadViewIfNeeded()
        sut.signUp?(makeSignUpViewModel())
        let exp = expectation(description: "waiting")
        DispatchQueue.global().async {
            addAccount.completeWithError(.unexpectedError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_should_compose_with_correct_validations() {
        let validations = SignUpComposer.makeValidations()
        XCTAssertEqual(validations[0] as! RequiredFieldValidation, RequiredFieldValidation(
            fieldName: "name",
            fieldLabel: "Nome"
        ))
        XCTAssertEqual(validations[1] as! RequiredFieldValidation, RequiredFieldValidation(
            fieldName: "email",
            fieldLabel: "Email"
        ))
        XCTAssertEqual(validations[2] as! EmailVadation, EmailVadation(
            fieldName: "email",
            fieldLabel: "Email",
            emailValidator: EmailValidatorSpy()
        ))
        XCTAssertEqual(validations[3] as! RequiredFieldValidation, RequiredFieldValidation(
            fieldName: "password",
            fieldLabel: "Password"
        ))
        XCTAssertEqual(validations[4] as! RequiredFieldValidation, RequiredFieldValidation(
            fieldName: "passwordConfirmation",
            fieldLabel: "Password Confirmation"
        ))
        XCTAssertEqual(validations[5] as! CompareFieldsValidation, CompareFieldsValidation(
            fieldName: "password",
            fieldLabel: "Password Confirmation",
            fieldToCompare: "passwordConfirmation"
        ))
    }
}

extension SignUpComposerTests {
    func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: SignUpViewController, addAccount: AddAccountSpy) {
        let addAccount = AddAccountSpy()
        let sut = SignUpComposer.makeViewController(addAccount: MainQueueDispatchDecorator(addAccount))
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: addAccount, file: file, line: line)
        return (sut, addAccount)
    }
}
