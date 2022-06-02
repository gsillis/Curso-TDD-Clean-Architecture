//
//  MainQueueDispatchDecorator.swift
//  Main
//
//  Created by Gabriela Sillis on 17/04/22.
//

import Foundation
import Domain

// Pattern that adds functionality to an instance of a class without change it

public final class MainQueueDispatchDecorator<T> {
    private var instance: T
    
    public init(_ instance: T) {
        self.instance = instance
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { completion() }
        }
        completion()
    }
}

extension MainQueueDispatchDecorator: AddAccount where T: AddAccount {
    public func add(addAccountModel: AddAccountModel, completion: @escaping (AddAccount.Result) -> Void) {
        instance.add(addAccountModel: addAccountModel) { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}


extension MainQueueDispatchDecorator: Authentication where T: Authentication {
    public func auth(authenticationModel: AuthenticationModel, completion: @escaping (Authentication.Result) -> Void) {
        instance.auth(authenticationModel: authenticationModel) { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
