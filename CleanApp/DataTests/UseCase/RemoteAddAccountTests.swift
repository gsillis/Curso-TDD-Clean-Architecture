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
            httpPostClientSpy.completeWith(error: .noConnectivity)
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

    func test_add_should_not_complet_if_sut_has_been_deallocated() {
        let httpPostClientSpy = HttpClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: makeURL(), httpPostClient: httpPostClientSpy)
        var result: Result<AccountModel, DomainError>?
        sut?.add(addAccountModel: makeAddAccountModel()) { result = $0 }
        sut = nil
        httpPostClientSpy.completeWith(error: .noConnectivity)
        XCTAssertNil(result)
    }
}

// MARK: Helpers
extension RemoteAddAccountTests {

    func makeSut(
        url: URL = URL(string: "http://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpPostClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpPostClientSpy)
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: httpPostClientSpy)
        return (sut, httpPostClientSpy)
    }

    func expect(_ sut: RemoteAddAccount,
                completeWith expectedResult: Result<AccountModel, DomainError>,
                when action: () -> Void,
                file: StaticString = #filePath,
                line: UInt = #line) {
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
        return AddAccountModel(
            name: "any_name",
            email: "any_email",
            password: "any_password",
            passwordConfirmation: "any_password"
        )
    }
}
