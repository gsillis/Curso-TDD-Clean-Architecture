//
//  AccountModelFactory.swift
//  DataTests
//
//  Created by Gabriela Sillis on 13/01/22.
//

import Foundation
import Domain

func makeAccountModel() -> AccountModel {
    return AccountModel(
        name: "any_name",
        email: "any_email",
        password: "any_password",
        id: "any_id"
    )
}
