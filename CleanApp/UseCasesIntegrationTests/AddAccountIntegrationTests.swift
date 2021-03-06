//
//  AddAccountIntegrationTests.swift.swift
//  UseCasesIntegrationTests
//
//  Created by Gabriela Sillis on 21/02/22.
//

import XCTest
import Domain
import Data
import Infra

class AddAccountIntegrationTests: XCTestCase {

    func test_add_account() {
        let url = URL(string: "https://fordevs.herokuapp.com/api/signup")!
        let alamofireAdapter = AlamofireAdapter()
        let sut = RemoteAddAccount(url: url, httpPostClient: alamofireAdapter)
        let string = UUID.init().uuidString
        let addAccountModel = AddAccountModel(name: "Gabriela", email: "\(string)@gmail.com", password: "secret", passwordConfirmation: "secret")
        
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure:
                XCTFail("Expect success got \(result) instead")
            case .success(let account):
                XCTAssertNotNil(account.accessToken)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        let exp2 = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure(let error) where error == .emailInUse:
                XCTAssertNotNil(error)
            default:
                XCTFail("Expect success got \(result) instead")
            }
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 5)
    }
}
