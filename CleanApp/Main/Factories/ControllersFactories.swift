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
            alertView: WeakVarProxy(instance: controller),
            emailValidator: emailValidator,
            addAccount: remoteAddAccount,
            loadingView: WeakVarProxy(instance: controller)
        )
        controller.signUp = presenter.signUp
        return controller
    }
}


class WeakVarProxy<T: AnyObject> {
    private weak var instance: T?
    
    init(instance: T) {
        self.instance = instance
    }
}

extension WeakVarProxy: AlertView where T: AlertView {
    func showMessage(viewModel: AlertViewModel) {
        instance?.showMessage(viewModel: viewModel)
    }
}

extension WeakVarProxy: LoadingView where T: LoadingView {
    func show(viewModel: LoadingViewModel) {
        instance?.show(viewModel: viewModel)
    }
}

