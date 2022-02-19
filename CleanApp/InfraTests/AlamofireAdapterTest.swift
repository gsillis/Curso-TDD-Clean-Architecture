//
//  AlamofireAdapterTest.swift
//  InfraTests
//
//  Created by Gabriela Sillis on 09/02/22.
//

import XCTest
import Data
import Alamofire

class AlamofireAdapter {
	typealias AFResult = ((Result<Data, HttpError>) -> Void)
	
    let session: Session
    init(session: Session = .default) {
        self.session = session
    }
    
	func post(to url: URL, with data: Data?, completion: @escaping (AFResult)) {
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
		let sut = makeSut()
		URLProtocolStub.simulate(data: nil, response: nil, error: makeError())
		
		let exp = expectation(description: "waiting")
		sut.post(to: makeURL(), with: makeValidData()) { result in
			switch result {
			case .failure(let error):
				XCTAssertEqual(error, .noConnectivityError)
			case .success:
				break
			}
			exp.fulfill()
		}
		
		wait(for: [exp], timeout: 1)
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
		sut.post(to: url, with: data) {_ in }
		let expectation = expectation(description: "waiting")
		URLProtocolStub.observerRequest { request in
			completion(request)
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 1)
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
