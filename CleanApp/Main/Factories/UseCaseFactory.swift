//
//  UseCaseFactory.swift
//  Main
//
//  Created by Gabriela Sillis on 12/04/22.
//

import Foundation
import Infra
import Domain
import Data

final class UseCaseFactory {
    private static let httpClient = AlamofireAdapter()
    private static let apiBaseUrl = Environment.variable(.apiBaseURL)
    
    static func makeURL(path: String) -> URL {
        return URL(string: "\(apiBaseUrl)/\(path)")!
    }
    
    static func makeRemoteAddAccount() -> AddAccount {
        return RemoteAddAccount(url: makeURL(path: "signup"), httpPostClient: httpClient)
    }
}
