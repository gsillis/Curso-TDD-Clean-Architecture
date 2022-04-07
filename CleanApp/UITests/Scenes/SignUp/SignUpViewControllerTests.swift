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

class SignUpViewControllerTests: XCTestCase {
    
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
    
    func test_saveButton_calls_signUp_on_tap() {
        var signViewModel: SignUpViewModel?
        let sut = makeSut(signUpSpy: {signViewModel = $0})
        let name = sut.nameTextfield?.text
        let email = sut.emailTextfield?.text
        let password = sut.passwordTextfield?.text
        let passwordConfirmation = sut.passwordConfirmationTextfield?.text
        sut.saveButton?.simulateTap()
        XCTAssertEqual(signViewModel, SignUpViewModel(
            name: name,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation
        ))
    }
}

extension SignUpViewControllerTests {
    func makeSut(signUpSpy: ((SignUpViewModel) -> Void)? = nil) -> SignUpViewController{
        let sb = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = sb.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        sut.signUp = signUpSpy
        sut.loadViewIfNeeded()
        return sut
    }
}

