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
        let addAccountModel = makeAddAccountModel()
        let expectation = expectation(description: "waiting")

        sut.add(addAccountModel: addAccountModel) { result in

            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unexpectedError)
            case .success:
                XCTFail("Expected error received \(result) instead")
            }
            expectation.fulfill()
        }
        httpPostClientSpy.completeWith(error: .noConnectivityError)
        wait(for: [expectation], timeout: 1)
    }

    func test_add_should_complete_with_account_if_client_completes_with_data() {
        let (sut, httpPostClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        let expectation = expectation(description: "waiting")
        let expectedAccount = makeAccountModel()

        sut.add(addAccountModel: addAccountModel) { result in

            switch result {
                case .failure:
                    XCTFail("Expected success received \(result) instead")
                case .success(let receivedAccount):
                    XCTAssertEqual(receivedAccount, expectedAccount)
            }
            expectation.fulfill()
        }
        httpPostClientSpy.completeWith(data: expectedAccount.toData()!)
        wait(for: [expectation], timeout: 1)
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
