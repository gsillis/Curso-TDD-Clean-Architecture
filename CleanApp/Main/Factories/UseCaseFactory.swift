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
    static func makeRemoteAddAccount() -> AddAccount {
        let alamofire = AlamofireAdapter()
        let url = URL(string: "http://fordevs.herokuapp.com/api/signup")!
        return RemoteAddAccount(url: url, httpPostClient: alamofire)
    }
}
