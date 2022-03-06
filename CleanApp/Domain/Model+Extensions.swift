//
//  Model+Extensions.swift
//  Domain
//
//  Created by Gabriela Sillis on 16/12/21.
//

import Foundation

public protocol Model: Codable, Equatable {}

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
