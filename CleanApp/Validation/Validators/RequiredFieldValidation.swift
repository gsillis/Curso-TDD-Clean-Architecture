//
//  RequiredFieldValidation.swift
//  Validation
//
//  Created by Gabriela Sillis on 27/04/22.
//

import Foundation
import PresentationLayer

public final class RequiredFieldValidation: Validation, Equatable {
    private let fieldName: String
    private let fieldLabel: String
    
    public init(fieldName: String, fieldLabel: String) {
        self.fieldName = fieldName
        self.fieldLabel = fieldLabel
    }
    
    public func validate(data: [String : Any]?) -> String? {
        guard let field = data?[fieldName] as? String, !field.isEmpty else {
            return "O campo \(fieldLabel) é obrigatório"
        }
        return nil
    }
    
    public static func == (lhs: RequiredFieldValidation, rhs: RequiredFieldValidation) -> Bool {
        return lhs.fieldName == rhs.fieldName && lhs.fieldLabel == rhs.fieldLabel
    }
    
}
