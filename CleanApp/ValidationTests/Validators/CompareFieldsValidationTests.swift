//
//  CompareFieldsValidationTests.swift
//  ValidationTests
//
//  Created by Gabriela Sillis on 27/04/22.
//

import XCTest
import PresentationLayer
import Validation

class CompareFieldsValidationTests: XCTestCase {
    
    func test_validate_should_return_error_if_field_is_not_provided() {
        let sut = makeSut(fieldName: "password", fieldLabel: "Senha", fieldToCompare: "passwordConfirmation")
        let errorMessage = sut.validate(data: ["password" : "123", "passwordConfirmation": "1234"])
        XCTAssertEqual(errorMessage, "O campo Senha é inválido")
    }
    
    func test_validate_should_return_error_message_with_correct_fieldLabel() {
        let sut = makeSut(fieldName: "password", fieldLabel: "Confirmar Senha", fieldToCompare: "passwordConfirmation")
        let errorMessage = sut.validate(data: ["password" : "123", "passwordConfirmation": "1234"])
        XCTAssertEqual(errorMessage, "O campo Confirmar Senha é inválido")
    }
    
    func test_validate_should_return_nil_if_field_is_provided() {
        let sut = makeSut(fieldName: "password", fieldLabel: "Idade", fieldToCompare: "passwordConfirmation")
        let errorMessage = sut.validate(data: ["password" : "123", "passwordConfirmation": "123"])
        XCTAssertNil(errorMessage)
    }
    
    func test_validate_should_return_error_message_if_no_data_is_provided() {
        let sut = makeSut(fieldName: "password", fieldLabel: "Senha", fieldToCompare: "passwordConfirmation")
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual(errorMessage, "O campo Senha é inválido")
    }
}

extension CompareFieldsValidationTests {
    func makeSut(
        fieldName: String,
        fieldLabel: String,
        fieldToCompare: String,
        file: StaticString = #filePath,
        line: UInt = #line) -> Validation {
        let sut = CompareFieldsValidation(fieldName: fieldName, fieldLabel: fieldLabel, fieldToCompare: fieldToCompare)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}

