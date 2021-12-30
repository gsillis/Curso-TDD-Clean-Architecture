//
//  AccountModel.swift
//  Domain
//
//  Created by Gabriela Sillis on 14/12/21.
//

import Foundation

public struct AccountModel: Model {
    public let id: String
    public let name: String
    public let email: String
    public let password: String

    public init(name: String, email: String, password: String, id: String ) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
}
