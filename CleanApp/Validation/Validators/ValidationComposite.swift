//
//  ValidationComposite.swift
//  Validation
//
//  Created by Gabriela Sillis on 05/05/22.
//

import PresentationLayer

public final class ValidationComposite: Validation {
    private let validations: [Validation]

    public init(validations: [Validation]) {
        self.validations = validations
    }
    
    public func validate(data: [String : Any]?) -> String? {
        for validation in validations {
            if let errorMessage = validation.validate(data: data) {
                return errorMessage
            }
        }
        return nil
    }
}
