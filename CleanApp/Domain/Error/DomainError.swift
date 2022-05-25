//
//  DomainError.swift
//  Domain
//
//  Created by Gabriela Sillis on 30/12/21.
//

import Foundation

public enum DomainError: Error {
    case unexpectedError
    case emailInUse
    case sessionExpired
}
