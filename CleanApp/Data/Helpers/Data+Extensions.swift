//
//  Data+Extensions.swift
//  Data
//
//  Created by Gabriela Sillis on 30/12/21.
//

import Foundation

public extension Data {

    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
