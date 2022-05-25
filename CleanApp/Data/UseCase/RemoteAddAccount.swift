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

    public func add(addAccountModel: AddAccountModel, completion: @escaping (AddAccount.Result) -> Void) {
        httpPostClient.post(to: url, with: addAccountModel.toData()) { [weak self] result in
            guard self != nil else { return }
            /// Essa var serve para testar memory leak
            var _ = self?.url
            switch result {
            case .success(let data):
                    if let model: AccountModel = data?.toModel()  {
                        completion(.success(model))
                    } else {
                        completion(.failure(.unexpectedError))
                    }
            case .failure(let error):
                switch error {
                case .forbidden:
                    completion(.failure(.emailInUse))
                default:
                    completion(.failure(.unexpectedError))
                }
            }
        }
    }
}
