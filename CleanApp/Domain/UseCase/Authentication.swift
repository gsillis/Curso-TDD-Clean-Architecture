//
//  Authentication.swift
//  Domain
//
//  Created by Gabriela Sillis on 25/05/22.
//

import Foundation

public protocol Authentication  {
    typealias Result = Swift.Result<AccountModel, DomainError>
    func auth(authenticationModel: AuthenticationModel, completion: @escaping (AddAccount.Result) -> Void)
}
