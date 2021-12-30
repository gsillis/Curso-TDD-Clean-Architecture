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
        let url = makeURL()
        let (sut, httpPostClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: makeAddAccountModel()) { _ in }

        XCTAssertEqual(httpPostClientSpy.urls, [url])
    }

    func test_add_should_call_httpClient_with_correct_data() {
        let (sut, httpPostClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel) { _ in }

        XCTAssertEqual(httpPostClientSpy.data, addAccountModel.toData())
    }

    func test_add_should_complete_with_error_if_client_completes_with_error() {
        let (sut, httpPostClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpectedError), when: {
            httpPostClientSpy.completeWith(error: .noConnectivityError)
        })
    }


    func test_add_should_complete_with_account_if_client_completes_with_data() {
        let (sut, httpPostClientSpy) = makeSut()
        let account = makeAccountModel()
        expect(sut, completeWith: .success(account), when:  {
            httpPostClientSpy.completeWith(data: account.toData()!)
        })
}

    func test_add_should_complete_with_error_if_client_completes_with_invalid_data() {
        let (sut, httpPostClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpectedError), when: {
            httpPostClientSpy.completeWith(data: makeInvalidData())
        })
    }
}

// MARK: Helpers
extension RemoteAddAccountTests {

    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpPostClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpPostClientSpy)
        return (sut, httpPostClientSpy)
    }

    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: Result<AccountModel, DomainError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let expectation = expectation(description: "waiting")

        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in

            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)):
                    XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedAccount), .success(let receivedAccount)):
                XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) received \(receivedResult) instead", file: file, line: line)
            }
            expectation.fulfill()
        }
        action()
        wait(for: [expectation], timeout: 1)
    }

    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email", password: "any_password", passwordConfirmation: "any_password")
    }

    func makeURL() -> URL {
        return URL(string: "http://any-url.com")!
    }

    func makeInvalidData() -> Data {
        return Data("invalid_data".utf8)
    }

    func makeAccountModel() -> AccountModel {
        return AccountModel(name: "any_name", email: "any_email", password: "any_password", id: "any_id")
    }

    class HttpClientSpy: HttpPostClient {
        fileprivate var urls = [URL]()
        fileprivate var data: Data?
        fileprivate var completion: ((Result<Data, HttpError>) -> Void)?

        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
            urls.append(url)
            self.data = data
            self.completion = completion
        }

        fileprivate func completeWith(error: HttpError) {
            completion?(.failure(error))
        }

        fileprivate func completeWith(data: Data) {
            completion?(.success(data))
        }
    }
}
