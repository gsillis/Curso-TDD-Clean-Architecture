//
//  HttpError.swift
//  Data
//
//  Created by Gabriela Sillis on 30/12/21.
//

import Foundation

public enum HttpError: Error {
    case noConnectivity
	case badRequest
	case serverError
	case unauthorized
	case forbidden
}
