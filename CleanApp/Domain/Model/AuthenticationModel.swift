//
//  AuthenticationModel.swift
//  Domain
//
//  Created by Gabriela Sillis on 25/05/22.
//

import Foundation

public struct AuthenticationModel: Model {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
