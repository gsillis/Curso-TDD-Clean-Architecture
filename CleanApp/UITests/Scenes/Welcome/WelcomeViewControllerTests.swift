//
//  WelcomeViewControllerTests.swift
//  WelcomeViewControllerTests
//
//  Created by Gabriela Sillis on 02/06/22.
//

import XCTest
import UIKit
import PresentationLayer
@testable import UI

class WelcomeViewControllerTests: XCTestCase {
    func test_loginButton_calls_login_on_tap() {
        let (sut, buttonSpy) = makeSut()
        sut.loginButton?.simulateTap()
        XCTAssertEqual(buttonSpy.clicks, 1)
    }
    
    func test_signUpButton_calls_signUp_on_tap() {
        let (sut, buttonSpy) = makeSut()
        sut.signUpButton?.simulateTap()
        XCTAssertEqual(buttonSpy.clicks, 1)
    }
}

extension WelcomeViewControllerTests {
    func makeSut() -> (sut: WelcomeViewController, buttonSpy: ButtonSpy) {
        let sut = WelcomeViewController.instantiate()
        let button = ButtonSpy()
        sut.login = button.onCLick
        sut.signUp = button.onCLick
        sut.loadViewIfNeeded()
        checkMemoryLeak(for: sut)
        return (sut, button)
    }
    
    class ButtonSpy {
        var clicks = 0
        
        func onCLick() {
            clicks += 1
        }
    }
}
