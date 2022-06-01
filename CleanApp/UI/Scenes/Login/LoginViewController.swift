//
//  SignUpViewController.swift
//  UI
//
//  Created by Gabriela Sillis on 07/04/22.
//

import UIKit
import PresentationLayer

public final class LoginViewController: UIViewController, Storyboarded {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextfield: RoundedTextField!
    @IBOutlet weak var emailTextfield: RoundedTextField!
    
    public var login: ((LoginViewModel) -> Void)? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        delegate()
    }
    
    private func configure() {
        title = "4Devs"
        loginButton.layer.cornerRadius = 5
        hideKeyboardOnTap()
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    private func delegate() {
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    }
}

extension LoginViewController: LoadingView {
    public func show(viewModel: LoadingViewModel) {
        if viewModel.isLoading ?? false {
            view.isUserInteractionEnabled = false
            loadingIndicator.startAnimating()
        } else {
            view.isUserInteractionEnabled = true
            loadingIndicator.stopAnimating()
        }
    }
}

extension LoginViewController: AlertView {
    public func showMessage(viewModel: AlertViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

@objc
private extension LoginViewController {
    func loginButtonTapped() {
        login?(LoginViewModel(
            email: emailTextfield.text,
            password: passwordTextfield.text)
        )
    }
}
