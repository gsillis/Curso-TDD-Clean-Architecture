//
//  RemoteAuthenticationTests.swift
//  DataTests
//
//  Created by Gabriela Sillis on 25/05/22.
//

import XCTest
import Alamofire
import Domain
import Data

class RemoteAuthenticationTests: XCTestCase {
    func test_auth_should_call_httpClient_with_correct_url() {
        let url = makeURL()
        let (sut, httpPostClientSpy) = makeSut(url: url)
        let authenticationModel = makeAuthenticationModel()
        sut.auth(authenticationModel: authenticationModel) { _ in }
        
        XCTAssertEqual(httpPostClientSpy.urls, [url])
    }
    
    func test_auth_should_call_httpClient_with_correct_data() {
        let (sut, httpPostClientSpy) = makeSut()
        let authenticationModel = makeAuthenticationModel()
        sut.auth(authenticationModel: authenticationModel) { _ in }
        
        XCTAssertEqual(httpPostClientSpy.data, authenticationModel.toData())
    }
    
    func test_auth_should_complete_with_error_if_client_completes_with_error() {
        let (sut, httpPostClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpectedError), when: {
            httpPostClientSpy.completeWith(error: .noConnectivity)
        })
    }
    
    func test_add_should_complete_with_email_in_use_error_if_client_completes_with_unauthorized() {
        let (sut, httpPostClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.sessionExpired), when: {
            httpPostClientSpy.completeWith(error: .unauthorized)
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
        var sut: RemoteAuthentication? = RemoteAuthentication(url: makeURL(), httpPostClient: httpPostClientSpy)
        var result: Authentication.Result?
        sut?.auth(authenticationModel: makeAuthenticationModel()) { result = $0 }
        sut = nil
        httpPostClientSpy.completeWith(error: .noConnectivity)
        XCTAssertNil(result)
    }
}


// MARK: Helpers
extension RemoteAuthenticationTests {
    func makeSut(
        url: URL = URL(string: "http://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line) -> (sut: RemoteAuthentication, httpClientSpy: HttpClientSpy) {
            let httpPostClientSpy = HttpClientSpy()
            let sut = RemoteAuthentication(url: url, httpPostClient: httpPostClientSpy)
            checkMemoryLeak(for: sut)
            checkMemoryLeak(for: httpPostClientSpy)
            return (sut, httpPostClientSpy)
        }
    
    func expect(_ sut: RemoteAuthentication,
                completeWith expectedResult: Authentication.Result,
                when action: () -> Void,
                file: StaticString = #filePath,
                line: UInt = #line) {
        let expectation = expectation(description: "waiting")
        
        sut.auth(authenticationModel: makeAuthenticationModel()) { receivedResult in
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
}
