//
//  SignUpIntegrationTests.swift
//  MainTests
//
//  Created by Gabriela Sillis on 12/04/22.
//

import XCTest
import Main

class SignUpIntegrationTests: XCTestCase {
    func test_memory_leak_when_ui_integrates_with_presentation()  {
        debugPrint(Environment.variable(.apiBaseURL))
        let sut = SignUpComposer.makeViewController(addAccount: AddAccountSpy())
        checkMemoryLeak(for: sut)
    }

}
