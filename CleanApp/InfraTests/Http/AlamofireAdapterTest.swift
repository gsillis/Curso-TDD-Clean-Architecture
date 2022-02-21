//
//  AlamofireAdapterTest.swift
//  InfraTests
//
//  Created by Gabriela Sillis on 09/02/22.
//

import XCTest
import Data
import Alamofire
import Infra

class AlamofireAdapterTest: XCTestCase {
	func test_post_should_make_request_with_valid_url_and_method()  {
		let url = makeURL()
		testRequestFor(url: url, data: makeValidData()) { request in
			XCTAssertEqual(url, request.url)
			XCTAssertEqual("POST", request.httpMethod)
			XCTAssertNotNil(request.httpBodyStream)
		}
	}
	
	func test_post_should_make_request_with_no_data()  {
		testRequestFor(url: makeURL(), data: nil) { request in
			XCTAssertNil(request.httpBodyStream)
		}
	}
	
	func test_post_should_complete_with_error_when_request_completes_with_error()  {
		expectResult(.failure(.noConnectivity), when: (nil, nil, makeError()))
	}
	
	func test_post_should_complete_with_error_on_all_invalid_cases()  {
		expectResult(.failure(.noConnectivity), when: (makeValidData(), makeResponse(), makeError()))
		expectResult(.failure(.noConnectivity), when: (makeValidData(), nil, makeError()))
		expectResult(.failure(.noConnectivity), when: (makeValidData(), nil, nil))
		expectResult(.failure(.noConnectivity), when: (nil, makeResponse(), makeError()))
		expectResult(.failure(.noConnectivity), when: (nil, makeResponse(), nil))
		expectResult(.failure(.noConnectivity), when: (nil, nil, nil))
	}
	
	func test_post_should_complete_with_data_when_request_completes_with_200()  {
		expectResult(.success(makeValidData()), when: (makeValidData(), makeResponse(), nil))
	}
	
	func test_post_should_complete_with_no_data_when_request_completes_with_204()  {
		expectResult(.success(nil), when: (nil, makeResponse(statusCode: 204), nil))
		expectResult(.success(nil), when: (makeEmptyData(), makeResponse(statusCode: 204), nil))
		expectResult(.success(nil), when: (makeValidData(), makeResponse(statusCode: 204), nil))
	}
	
	func test_post_should_complete_with_error_when_request_completes_with_non_200()  {
		expectResult(.failure(.badRequest), when: (makeValidData(), makeResponse(statusCode: 400), nil))
		expectResult(.failure(.serverError), when: (makeValidData(), makeResponse(statusCode: 500), nil))
		expectResult(.failure(.unauthorized), when: (makeValidData(), makeResponse(statusCode: 401), nil))
		expectResult(.failure(.forbidden), when: (makeValidData(), makeResponse(statusCode: 403), nil))
		expectResult(.failure(.noConnectivity), when: (makeValidData(), makeResponse(statusCode: 300), nil))
	}
}

extension AlamofireAdapterTest {
	
	typealias StubTuple = (data: Data?, response: HTTPURLResponse?, error: Error?)
	
	func makeSut(file: StaticString = #filePath, line: UInt = #line) -> AlamofireAdapter {
		let configuration = URLSessionConfiguration.default
		configuration.protocolClasses = [URLProtocolStub.self]
		let session = Session(configuration: configuration)
		let sut = AlamofireAdapter(session: session)
		checkMemoryLeak(for: sut, file: file, line: line)
		return sut
	}
	
	func testRequestFor(url: URL, data: Data?, completion: @escaping (URLRequest) -> Void) {
		let sut = makeSut()
		let expectation = expectation(description: "waiting")
		sut.post(to: url, with: data) {_ in expectation.fulfill() }
		var request: URLRequest?
		URLProtocolStub.observerRequest { request = $0 }
		wait(for: [expectation], timeout: 1)
		completion(request!)
	}
	
	func expectResult(_ expectedResult: (Result<Data?, HttpError>), when stub: StubTuple, file: StaticString = #filePath, line: UInt = #line) {
		let sut = makeSut()
		URLProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)
		
		let exp = expectation(description: "waiting")
		sut.post(to: makeURL(), with: makeValidData()) { receivedResult in
			
			switch (expectedResult, receivedResult) {
			case (.failure(let expectedError), .failure(let receivedError)):
				XCTAssertEqual(expectedError, receivedError, file: file, line: line)
			case (.success(let expectedSuccess), .success(let receivedSuccess)):
				XCTAssertEqual(expectedSuccess, receivedSuccess, file: file, line: line)
			default:
				XCTFail("Expected \(expectedResult) got \(receivedResult) instead", file: file, line: line)
			}
			exp.fulfill()
		}
		wait(for: [exp], timeout: 1)
	}
}
