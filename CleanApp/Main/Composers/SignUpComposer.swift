//
//  SignUpComposer.swift
//  Main
//
//  Created by Gabriela Sillis on 12/04/22.
//

import UI
import PresentationLayer
import Validation
import Data
import Infra
import Domain

public final class SignUpComposer {
    public static func makeViewController(addAccount: AddAccount) -> SignUpViewController {
        let controller =  SignUpViewController.instantiate()
        let emailValidator = EmailValidatorAdapter()
        let presenter = SignUpPresenter(
            alertView: WeakVarProxy(instance: controller),
            emailValidator: emailValidator,
            addAccount: addAccount,
            loadingView: WeakVarProxy(instance: controller)
        )
        controller.signUp = presenter.signUp
        return controller
    }
}
