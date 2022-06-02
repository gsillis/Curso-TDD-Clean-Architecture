//
//  UITests.swift
//  UITests
//
//  Created by Gabriela Sillis on 07/04/22.
//

import XCTest
import UIKit
import PresentationLayer
@testable import UI

class LoginViewControllerTests: XCTestCase {
    
    func test_loading_is_hidden_on_start_vc() {
        let sut = makeSut()
        XCTAssertEqual(sut.loadingIndicator?.isAnimating, false)
    }
    
    func test_sut_implements_loadingView() {
        let sut = makeSut()
        XCTAssertNotNil(sut as LoadingView)
    }
    
    func test_sut_implements_alertView() {
        let sut = makeSut()
        XCTAssertNotNil(sut as AlertView)
    }
    
    func test_loginButton_calls_login_on_tap() {
        var loginViewModel: LoginViewModel?
        let sut = makeSut(loginSpy: {loginViewModel = $0})
        let email = sut.emailTextfield?.text
        let password = sut.passwordTextfield?.text
        sut.loginButton?.simulateTap()
        XCTAssertEqual(loginViewModel, LoginViewModel(
            email: email,
            password: password
        ))
    }
}

extension LoginViewControllerTests {
    func makeSut(loginSpy: ((LoginViewModel) -> Void)? = nil) -> LoginViewController{
        let sut = LoginViewController.instantiate()
        sut.login = loginSpy
        sut.loadViewIfNeeded()
        checkMemoryLeak(for: sut)
        return sut
    }
}

