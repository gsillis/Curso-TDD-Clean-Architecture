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
    
    func post(to url: URL) {
        session.request(url, method: .post).resume()
    }
}

class AlamofireAdapterTest: XCTestCase {
    func testExample()  {
        let url = makeURL()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        sut.post(to: url)
        let expectation = expectation(description: "waiting")
        URLProtocolStub.observerRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
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
