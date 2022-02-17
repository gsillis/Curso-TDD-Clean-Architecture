//
//  AlamofireAdapterTest.swift
//  InfraTests
//
//  Created by Gabriela Sillis on 09/02/22.
//

import XCTest
import Alamofire

class AlamofireAdapter {
    let session: Session
    init(session: Session = .default) {
        self.session = session
    }
    
	func post(to url: URL, with data: Data?) {
		let json = data == nil ?
		nil :
		try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any]
		
        session.request(
			url,
			method: .post,
			parameters: json,
			encoding: JSONEncoding.default).resume()
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
		sut.post(to: url, with: data)
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
    
    static func observerRequest(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
    }
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }
   
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return  request
    }

    override open func startLoading() {
        URLProtocolStub.emit?(request)
    }

    override open func stopLoading() {}

}
