//
//  SignUpComposer.swift
//  Main
//
//  Created by Gabriela Sillis on 12/04/22.
//

import Foundation
import UI
import Domain

public final class SignUpComposer {
    public static func makeViewController(addAccount: AddAccount) -> SignUpViewController {
        return ControllersFactory.makeSignUpController(remoteAddAccount: addAccount)
    }
}
