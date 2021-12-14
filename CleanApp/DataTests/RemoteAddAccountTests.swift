//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Gabriela Sillis on 14/12/21.
//

import XCTest

class RemoteAddAccount {
    private var url: URL
    private var httpPostClient: HttpPostClient

    init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }

    fileprivate func add() {
        httpPostClient.post(url: url)
    }
}

protocol HttpPostClient {
    func post(url: URL)
}


class RemoteAddAccountTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() {
        guard let url = URL(string: "http://any-url.com") else { return }
        let httpPostClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpPostClientSpy)
        sut.add()

        XCTAssertEqual(httpPostClientSpy.url, url)
    }

    class HttpClientSpy: HttpPostClient {
        fileprivate var url: URL?

        func post(url: URL) {
            self.url = url
        }
    }
}

