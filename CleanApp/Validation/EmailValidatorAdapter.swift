//
//  EmailValidatorAdapter.swift
//  Validation
//
//  Created by Gabriela Sillis on 10/04/22.
//

import Foundation
import PresentationLayer

public final class EmailValidatorAdapter: EmailValidator {
    private let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    public init() {}
    
    public func isValid(email: String) -> Bool {
        let range = NSRange(location: 0, length: email.utf16.count)
        let regex = try? NSRegularExpression(pattern: regex)
        return regex?.firstMatch(in: email, options: [], range: range) != nil
    }
}
