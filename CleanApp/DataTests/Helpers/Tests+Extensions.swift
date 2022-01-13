//
//  Tests+Extensions.swift
//  DataTests
//
//  Created by Gabriela Sillis on 12/01/22.
//

import Foundation
import XCTest

extension XCTestCase {
    func checkMemoryLeak(
        for instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line) {
            addTeardownBlock { [weak instance] in
                XCTAssertNil(instance, file: file, line: line)
            }
        }
}
