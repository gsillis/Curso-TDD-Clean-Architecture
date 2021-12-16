//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Gabriela Sillis on 14/12/21.
//

import XCTest
import Domain

class RemoteAddAccount {
    private var url: URL
    private var httpPostClient: HttpPostClient

    init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }

    fileprivate func add(addAccountModel: AddAccountModel) {
        let encodedData = try? JSONEncoder().encode(addAccountModel)
        httpPostClient.post(to: url, with: encodedData)
    }
}

protocol HttpPostClient {
    func post(to url: URL, with data: Data?)
}


class RemoteAddAccountTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() {
        guard let url = URL(string: "http://any-url.com") else { return }
        let httpPostClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpPostClientSpy)
        let addAccountModel = AddAccountModel(name: "any_name", email: "any_email", password: "any_password", passwordConfirmation: "any_password")
        sut.add(addAccountModel: addAccountModel)

        XCTAssertEqual(httpPostClientSpy.url, url)
    }

    func test_add_should_call_httpClient_with_correct_data() {
        guard let url = URL(string: "http://any-url.com") else { return }
        let httpPostClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpPostClientSpy)
        let addAccountModel = AddAccountModel(name: "any_name", email: "any_email", password: "any_password", passwordConfirmation: "any_password")
        let encodedData = try? JSONEncoder().encode(addAccountModel)
        sut.add(addAccountModel: addAccountModel)

        XCTAssertEqual(httpPostClientSpy.data, encodedData)
    }
}

// MARK: Helpers
extension RemoteAddAccountTests {
    class HttpClientSpy: HttpPostClient {
        fileprivate var url: URL?
        fileprivate var data: Data?

        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
}
