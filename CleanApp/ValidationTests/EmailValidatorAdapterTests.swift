
//
//  ValidationTests.swift
//  ValidationTests
//
//  Created by Gabriela Sillis on 10/04/22.
//

import XCTest
import PresentationLayer
import Validation

class EmailValidatorAdapterTests: XCTestCase {

    func test_invalid_emails() {
        let sut = makeSut()
        XCTAssertFalse(sut.isValid(email: "gg"))
        XCTAssertFalse(sut.isValid(email: "gg@"))
        XCTAssertFalse(sut.isValid(email: "gg@gg"))
        XCTAssertFalse(sut.isValid(email: "@gg."))
        XCTAssertFalse(sut.isValid(email: "@gg.com"))
    }
    
    func test_valid_emails() {
        let sut = makeSut()
        XCTAssertTrue(sut.isValid(email: "gaby@gmail.com"))
        XCTAssertTrue(sut.isValid(email: "gaby@gmail.com.br"))
        XCTAssertTrue(sut.isValid(email: "gaby@hotmail.com"))
        XCTAssertTrue(sut.isValid(email: "gaby123@hotmail.com."))
        XCTAssertTrue(sut.isValid(email: "gaby+8778@hotmail.com"))
    }
}

extension EmailValidatorAdapterTests {
    func makeSut() -> EmailValidatorAdapter {
        return EmailValidatorAdapter()
    }
}
