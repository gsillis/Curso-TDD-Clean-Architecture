//
//  SignUpViewController.swift
//  UI
//
//  Created by Gabriela Sillis on 07/04/22.
//

import UIKit
import PresentationLayer

final class SignUpViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    
    var signUp: ((SignUpViewModel) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
}

extension SignUpViewController: LoadingView {
    func show(viewModel: LoadingViewModel) {
        if viewModel.isLoading ?? false {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}

extension SignUpViewController: AlertView {
    func showMessage(viewModel: AlertViewModel) {
        
    }
}

@objc
private extension SignUpViewController {
    func saveButtonTapped() {
        signUp?(SignUpViewModel(name: nil, email: nil, password: nil, passwordConfirmation: nil))
    }
}
