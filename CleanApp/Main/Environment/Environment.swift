//
//  Environment.swift
//  Main
//
//  Created by Gabriela Sillis on 15/04/22.
//

import Foundation

public final class Environment {
    public enum EnvironmentVariables: String {
        case apiBaseURL = "API_BASE_URL"
    }
    
    public static func variable(_ key: EnvironmentVariables) -> String {
        guard let variable = Bundle.main.infoDictionary?[key.rawValue] as? String else {
            return ""
        }
        return variable
    }
}
