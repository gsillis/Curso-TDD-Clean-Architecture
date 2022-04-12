//
//  SignUpFactory.swift
//  Main
//
//  Created by Gabriela Sillis on 11/04/22.
//

import UIKit
import UI
import PresentationLayer
import Validation
import Data
import Infra
import Domain

class ControllersFactory {
    static func makeSignUpController(remoteAddAccount: AddAccount) -> SignUpViewController {
        let controller =  SignUpViewController.instantiate()
        let emailValidator = EmailValidatorAdapter()
        let presenter = SignUpPresenter(
            alertView: controller,
            emailValidator: emailValidator,
            addAccount: remoteAddAccount,
            loadingView: controller
        )
        controller.signUp = presenter.signUp
        return controller
    }
}
