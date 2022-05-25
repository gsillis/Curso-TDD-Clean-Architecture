//
//  RemoteAuthentication.swift
//  Data
//
//  Created by Gabriela Sillis on 25/05/22.
//

import Foundation
import Domain

public final class RemoteAuthentication {
    private var url: URL
    private var httpPostClient: HttpPostClient
    
    public  init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }
    
    public func auth(authenticationModel: AuthenticationModel, completion: @escaping (Authentication.Result) -> Void) {
        httpPostClient.post(to: url, with: authenticationModel.toData()) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case.success(let data):
                if let data: AccountModel = data?.toModel() {
                    completion(.success(data))
                } else {
                    completion(.failure(.unexpectedError))
                }
            case .failure(let error):
                switch error {
                case .unauthorized:
                    completion(.failure(.sessionExpired))
                default:
                    completion(.failure(.unexpectedError))
                }
            }
        }
    }
}
