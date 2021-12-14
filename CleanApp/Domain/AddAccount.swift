//
//  AddAccount.swift
//  Domain
//
//  Created by Gabriela Sillis on 14/12/21.
//

import Foundation

protocol AddAccount  {
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, Error>) -> Void)
}



