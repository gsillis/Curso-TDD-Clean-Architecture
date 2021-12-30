//
//  RemoteAddAccount.swift
//  Data
//
//  Created by Gabriela Sillis on 16/12/21.
//

import Foundation
import Domain

public final class RemoteAddAccount: AddAccount {
    private var url: URL
    private var httpPostClient: HttpPostClient

   public  init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }

    public func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
        httpPostClient.post(to: url, with: addAccountModel.toData()) { result in

            switch result {
            case .success(let data):
                    if let model: AccountModel = data.toModel()  {
                        completion(.success(model))
                    }
            case .failure:
                completion(.failure(.unexpectedError))
            }
        }
    }
}
