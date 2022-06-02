//
//  LoginComposer.swift
//  Main
//
//  Created by Gabriela Sillis on 12/04/22.
//

import UI
import PresentationLayer
import Validation
import Data
import Domain
import Infra

public final class LoginComposer {
    public static func makeLoginViewController(authentication: Authentication) -> LoginViewController {
        let controller =  LoginViewController.instantiate()
        let validationComposite = ValidationComposite(validations: makeLoginValidations())
        let presenter = LoginPresenter(
            validation: validationComposite,
            alertView: WeakVarProxy(instance: controller),
            authentication: authentication,
            loadingView: WeakVarProxy(instance: controller)
        )
        controller.login = presenter.login
        return controller
    }
    
    public static func makeLoginValidations() -> [Validation] {
        return [
            RequiredFieldValidation(fieldName: "email",fieldLabel: "Email"),
            EmailVadation(fieldName: "email", fieldLabel: "Email", emailValidator: EmailValidatorAdapter()),
            RequiredFieldValidation(fieldName: "password",fieldLabel: "Password"),
        ]
    }
}
