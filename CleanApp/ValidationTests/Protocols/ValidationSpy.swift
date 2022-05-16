//
//  ValidationSpy.swift
//  ValidationTests
//
//  Created by Gabriela Sillis on 05/05/22.
//

import PresentationLayer

class ValidationSpy: Validation {
    private var errorMessage: String?
    var data: [String: Any]?
    
    func validate(data: [String : Any]?) -> String? {
        self.data = data
        return errorMessage
    }
    
    func simulateError(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
