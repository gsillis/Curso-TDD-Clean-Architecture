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
