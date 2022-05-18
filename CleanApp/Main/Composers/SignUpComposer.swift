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
import Domain
import Infra

public final class SignUpComposer {
    public static func makeViewController(addAccount: AddAccount) -> SignUpViewController {
        let controller =  SignUpViewController.instantiate()
        let validationComposite = ValidationComposite(validations: makeValidations())
        let presenter = SignUpPresenter(
            alertView: WeakVarProxy(instance: controller),
            addAccount: addAccount,
            loadingView: WeakVarProxy(instance: controller), validation: validationComposite
        )
        controller.signUp = presenter.signUp
        return controller
    }
    
    public static func makeValidations() -> [Validation] {
        return [
            RequiredFieldValidation(fieldName: "name",fieldLabel: "Nome"),
            RequiredFieldValidation(fieldName: "email",fieldLabel: "Email"),
            EmailVadation(fieldName: "email", fieldLabel: "Email", emailValidator: EmailValidatorAdapter()),
            RequiredFieldValidation(fieldName: "password",fieldLabel: "Password"),
            RequiredFieldValidation(fieldName: "passwordConfirmation",fieldLabel: "Password Confirmation"),
            CompareFieldsValidation(fieldName: "password", fieldLabel: "Password Confirmation", fieldToCompare: "passwordConfirmation"),
        ]
    }
}
