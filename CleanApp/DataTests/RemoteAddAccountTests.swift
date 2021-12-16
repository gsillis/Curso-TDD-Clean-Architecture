//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Gabriela Sillis on 14/12/21.
//

import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() {
        guard let url = URL(string: "http://any-url.com") else { return }
        let (sut, httpPostClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: makeAddAccountModel())

        XCTAssertEqual(httpPostClientSpy.url, url)
    }

    func test_add_should_call_httpClient_with_correct_data() {
        let (sut, httpPostClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel)

        XCTAssertEqual(httpPostClientSpy.data, addAccountModel.toData())
    }
}

// MARK: Helpers
extension RemoteAddAccountTests {

    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpPostClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpPostClientSpy)
        return (sut, httpPostClientSpy)
    }

    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email", password: "any_password", passwordConfirmation: "any_password")
    }

    class HttpClientSpy: HttpPostClient {
        fileprivate var url: URL?
        fileprivate var data: Data?

        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
}
