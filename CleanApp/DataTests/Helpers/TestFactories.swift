//
//  TestFactories.swift
//  DataTests
//
//  Created by Gabriela Sillis on 13/01/22.
//

import Foundation

func makeURL() -> URL {
	return URL(string: "http://any-url.com")!
}

func makeInvalidData() -> Data {
	return Data("invalid_data".utf8)
}

func makeValidData() -> Data {
	return Data("{\"name\":\"teste\"}".utf8)
}

func makeError() -> Error {
	return NSError(domain: "any_error", code: 0)
}

func makeResponse(statusCode: Int = 200) -> HTTPURLResponse {
	return HTTPURLResponse(url: makeURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

func makeEmptyData() -> Data {
	return Data()
}
