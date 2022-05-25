//
//  RoundedTextField.swift
//  UI
//
//  Created by Gabriela Sillis on 25/05/22.
//

import UIKit

public final class RoundedTextField: UITextField {
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextfield()
    }
    
    private func setupTextfield() {
        layer.borderColor = Color.primaryLight.cgColor
        layer.cornerRadius = 5
        layer.borderWidth = 1
    }
}
