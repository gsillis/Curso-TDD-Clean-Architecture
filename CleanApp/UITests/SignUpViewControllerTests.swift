//
//  UITests.swift
//  UITests
//
//  Created by Gabriela Sillis on 07/04/22.
//

import XCTest
import UIKit
@testable import UI

class SignUpViewControllerTests: XCTestCase {
    
    func test_loading_is_hidden_on_start_vc() {
        let sb = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = sb.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        sut?.loadViewIfNeeded()
        XCTAssertEqual(sut?.loadingIndicator?.isAnimating, false)
    }
}
