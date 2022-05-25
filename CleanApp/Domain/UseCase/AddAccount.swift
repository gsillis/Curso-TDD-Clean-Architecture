//
//  AddAccount.swift
//  Domain
//
//  Created by Gabriela Sillis on 14/12/21.
//

import Foundation

public protocol AddAccount  {
    typealias Result = Swift.Result<AccountModel, DomainError>
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result) -> Void)
}
