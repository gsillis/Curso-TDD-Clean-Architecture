//
//  SignUpIntegrationTests.swift
//  MainTests
//
//  Created by Gabriela Sillis on 12/04/22.
//

import XCTest
import Main
import UI

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
