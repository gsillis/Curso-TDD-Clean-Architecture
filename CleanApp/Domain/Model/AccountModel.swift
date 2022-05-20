//
//  AccountModel.swift
//  Domain
//
//  Created by Gabriela Sillis on 14/12/21.
//

import Foundation

public struct AccountModel: Model {
    public let accessToken: String
    public let name: String

    public init(name: String, accessToken: String) {
        self.accessToken = accessToken
        self.name = name
    }
}
