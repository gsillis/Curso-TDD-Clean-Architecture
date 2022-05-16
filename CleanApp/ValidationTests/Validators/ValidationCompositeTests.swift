//
//  ValidationCompositeTests.swift
//  ValidationTests
//
//  Created by Gabriela Sillis on 05/05/22.
//

import XCTest
import PresentationLayer
import Validation

class ValidationCompositeTests: XCTestCase {
    func test_validate_should_return_error_if_validation_fails() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validations: [validationSpy])
        validationSpy.simulateError(errorMessage: "Erro 1")
        let errorMessage = sut.validate(data: ["name" : "gabriela"])
        XCTAssertEqual(errorMessage, "Erro 1")
    }
    
    func test_validate_should_return_nil_if_validation_succeeds() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validations: [validationSpy])
        let errorMessage = sut.validate(data: ["name" : "gabriela"])
        XCTAssertNil(errorMessage)
    }
    
    func test_validate_should_call_validation_with_correct_data() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validations: [validationSpy])
        let data = ["name" : "Gabriela"]
        _ = sut.validate(data: data)
        XCTAssertTrue(NSDictionary(dictionary: validationSpy.data!).isEqual(to: data))
    }
    
    func test_validate_should_return_correct_error_message() {
        let validationSpy = ValidationSpy()
        let validationSpy2 = ValidationSpy()
        let sut = makeSut(validations: [validationSpy, validationSpy2])
        validationSpy2.simulateError(errorMessage: "Erro 3")
        let errorMessage = sut.validate(data: ["name" : "gabriela"])
        XCTAssertEqual(errorMessage, "Erro 3")
    }
    
    func test_validate_should_return_with_first_error_message() {
        let validationSpy = ValidationSpy()
        let validationSpy2 = ValidationSpy()
        let validationSpy3 = ValidationSpy()
        let sut = makeSut(validations: [validationSpy, validationSpy2, validationSpy3])
        validationSpy2.simulateError(errorMessage: "Erro 2")
        validationSpy3.simulateError(errorMessage: "Erro 3")
        let errorMessage = sut.validate(data: ["name" : "gabriela"])
        XCTAssertEqual(errorMessage, "Erro 2")
    }
}


extension ValidationCompositeTests {
    func makeSut(
        validations: [ValidationSpy],
        file: StaticString = #filePath,
        line: UInt = #line) -> Validation {
            let sut = ValidationComposite(validations: validations)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
