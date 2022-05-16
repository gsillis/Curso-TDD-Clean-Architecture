//
//  EmailValidatorSpy.swift
//  PresentationLayerTests
//
//  Created by Gabriela Sillis on 30/03/22.
//

import Foundation
import Validation

class EmailValidatorSpy: EmailValidator {
    var isValid: Bool = true
    var email: String?
    
    func isValid(email: String) -> Bool {
        self.email = email
        return isValid
    }
    
    func simulateInvalidEmail() {
        isValid = false
    }
}
