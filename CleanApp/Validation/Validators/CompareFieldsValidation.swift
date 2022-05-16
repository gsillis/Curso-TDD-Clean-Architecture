//
//  CompareFieldsValidation.swift
//  Validation
//
//  Created by Gabriela Sillis on 27/04/22.
//

import Foundation
import PresentationLayer

public final class CompareFieldsValidation: Validation, Equatable {
    private let fieldName: String
    private let fieldLabel: String
    private let fieldToCompare: String
    
    public init(fieldName: String, fieldLabel: String, fieldToCompare: String) {
        self.fieldName = fieldName
        self.fieldLabel = fieldLabel
        self.fieldToCompare = fieldToCompare
    }
    
    public func validate(data: [String : Any]?) -> String? {
        guard let field = data?[fieldName] as? String,
              let fieldToCompare = data?[fieldToCompare] as? String,
              field == fieldToCompare else {
            return "O campo \(fieldLabel) é inválido"
        }
        return nil
    }
    
    public static func == (lhs: CompareFieldsValidation, rhs: CompareFieldsValidation) -> Bool {
        return lhs.fieldName == rhs.fieldName && lhs.fieldToCompare == rhs.fieldToCompare && lhs.fieldLabel == rhs.fieldLabel
    }
}

