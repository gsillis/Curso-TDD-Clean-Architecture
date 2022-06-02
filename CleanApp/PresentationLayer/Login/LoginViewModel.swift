//
//  LoginViewModel.swift
//  PresentationLayer
//
//  Created by Gabriela Sillis on 31/05/22.
//

import Foundation
import Domain

public struct LoginViewModel: Model {
    public var email: String?
    public var password: String?
    
    public init(email: String? = nil, password: String? = nil) {
        self.email = email
        self.password = password
    }
    
    public func toAuthenticationModel() -> AuthenticationModel {
        return AuthenticationModel(
            email: email ?? "",
            password: password ?? ""
        )
    }
}
