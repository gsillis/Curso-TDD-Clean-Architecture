//
//  EmailValidationTests.swift
//  ValidationTests
//
//  Created by Gabriela Sillis on 29/04/22.
//

import XCTest
import PresentationLayer
import Validation



class EmailValidationTests: XCTestCase {
    func test_validate_should_return_error_if_invalid_email_is_provided() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(fieldName: "email", fieldLabel: "Email", emailValidator: emailValidatorSpy)
        emailValidatorSpy.simulateInvalidEmail()
        let errorMessage = sut.validate(data: ["email": "invad_email@gmail.com"])
        XCTAssertEqual(errorMessage, "O campo Email é inválido")
        
    }
    
    func test_validate_should_return_error_message_with_correct_fieldLabel() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(fieldName: "email", fieldLabel: "Email", emailValidator: emailValidatorSpy)
        emailValidatorSpy.simulateInvalidEmail()
        let errorMessage = sut.validate(data: ["email": "invad_email@gmail.com"])
        XCTAssertEqual(errorMessage, "O campo Email é inválido")
        
    }
    
    func test_validate_should_return_nil_if_valid_email_is_provided() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(fieldName: "email", fieldLabel: "Email", emailValidator: emailValidatorSpy)
        let errorMessage = sut.validate(data: ["email": "valid_email@gmail.com"])
        XCTAssertNil(errorMessage)
        
    }
    
    func test_validate_should_return_nil_if_no_data_is_provided() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(fieldName: "email", fieldLabel: "Email", emailValidator: emailValidatorSpy)
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual(errorMessage, "O campo Email é inválido")
        
    }
}

extension EmailValidationTests {
    func makeSut(
        fieldName: String,
        fieldLabel: String,
        emailValidator: EmailValidatorSpy,
        file: StaticString = #filePath,
        line: UInt = #line) -> Validation {
            let sut = EmailVadation(fieldName: fieldName, fieldLabel: fieldLabel, emailValidator: emailValidator)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
