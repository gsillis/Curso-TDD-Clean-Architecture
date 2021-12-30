//
//  RemoteAddAccount.swift
//  Data
//
//  Created by Gabriela Sillis on 16/12/21.
//

import Foundation
import Domain

public final class RemoteAddAccount {
    private var url: URL
    private var httpPostClient: HttpPostClient

   public  init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }

    public func add(addAccountModel: AddAccountModel, completion: @escaping (DomainError) -> Void) {
        httpPostClient.post(to: url, with: addAccountModel.toData()) { error in
            completion(.unexpectedError)
        }
    }
}
