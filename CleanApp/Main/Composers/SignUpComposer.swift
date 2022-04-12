//
//  SignUpComposer.swift
//  Main
//
//  Created by Gabriela Sillis on 12/04/22.
//

import Foundation
import UI
import Domain

final class SignUpComposer {
    static func makeViewController(addAccount: AddAccount) -> SignUpViewController {
        return ControllersFactory.makeSignUpController(remoteAddAccount: addAccount)
    }
}
