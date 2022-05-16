//
//  EmailValidator.swift
//  PresentationLayer
//
//  Created by Gabriela Sillis on 08/03/22.
//

import Foundation

public protocol EmailValidator {
    func isValid(email: String) -> Bool 
}
