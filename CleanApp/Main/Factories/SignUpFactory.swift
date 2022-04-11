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

class SignUpFactory {
    static func makeController() -> SignUpViewController {
        let controller =  SignUpViewController.instantiate()
        let emailValidator = EmailValidatorAdapter()
        let alamofire = AlamofireAdapter()
        let url = URL(string: "http://fordevs.herokuapp.com/api/signup")!
        let remoteAddAccount = RemoteAddAccount(url: url, httpPostClient: alamofire)
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
