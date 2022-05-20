//
//  SignUpViewController.swift
//  UI
//
//  Created by Gabriela Sillis on 07/04/22.
//

import UIKit
import PresentationLayer

public final class SignUpViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordConfirmationTextfield: UITextField!
    
    public var signUp: ((SignUpViewModel) -> Void)? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        delegate()
    }
    
    private func configure() {
        saveButton.layer.cornerRadius = 5
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        hideKeyboardOnTap()
    }
    
    private func delegate() {
        nameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        passwordConfirmationTextfield.delegate = self
    }
}

extension SignUpViewController: LoadingView {
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

extension SignUpViewController: AlertView {
    public func showMessage(viewModel: AlertViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
    }
}

@objc
private extension SignUpViewController {
    func saveButtonTapped() {
        signUp?(SignUpViewModel(
            name: nameTextfield.text,
            email: emailTextfield.text,
            password: passwordTextfield.text,
            passwordConfirmation: passwordConfirmationTextfield.text
        ))
    }
}

extension SignUpViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
