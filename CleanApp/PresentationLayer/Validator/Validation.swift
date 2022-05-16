//
//  Validation.swift
//  PresentationLayer
//
//  Created by Gabriela Sillis on 19/04/22.
//

import Foundation

public protocol Validation {
    func validate(data: [String: Any]?) -> String?
}
