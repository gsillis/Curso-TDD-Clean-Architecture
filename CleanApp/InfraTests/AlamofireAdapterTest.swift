//
//  AlamofireAdapterTest.swift
//  InfraTests
//
//  Created by Gabriela Sillis on 09/02/22.
//

import XCTest
import Data
import Alamofire

typealias AFResult = Result<Data, HttpError>
typealias StubTuple = (data: Data?, response: HTTPURLResponse?, error: Error?)

class AlamofireAdapter {
	
	
    let session: Session
    init(session: Session = .default) {
        self.session = session
    }
    
	func post(to url: URL, with data: Data?, completion: @escaping (AFResult) -> Void) {
		let json = data?.toJson()
		
		session.request(url, method: .post, parameters: json, encoding: JSONEncoding.default).responseData { dataResponse in
			switch dataResponse.result {
			case .failure:
				completion(.failure(.noConnectivityError))
			case .success:
				break
			}
		}
    }
}

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
		expectResult(.failure(.noConnectivityError), when: (nil, nil, makeError()))
	}
}

extension AlamofireAdapterTest {
	
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
	
	func expectResult(_ expectedResult: AFResult, when stub: StubTuple, file: StaticString = #filePath, line: UInt = #line) {
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

class URLProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
	static var data: Data?
	static var error: Error?
	static var response: HTTPURLResponse?
    
    static func observerRequest(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
    }
	
	static func simulate(data: Data?, response: HTTPURLResponse?, error: Error?) {
		URLProtocolStub.data = data
		URLProtocolStub.response = response
		URLProtocolStub.error = error
	}
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }
   
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return  request
    }

    override open func startLoading() {
        URLProtocolStub.emit?(request)
		
		if let data = URLProtocolStub.data {
			client?.urlProtocol(self, didLoad: data)
		}
		
		if let response = URLProtocolStub.response {
			client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
		}
		
		if let error = URLProtocolStub.error {
			client?.urlProtocol(self, didFailWithError: error)
		}
		client?.urlProtocolDidFinishLoading(self)
    }

    override open func stopLoading() {}

}
