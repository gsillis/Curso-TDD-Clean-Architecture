//
//  HttpPostClientProtocol.swift
//  Data
//
//  Created by Gabriela Sillis on 16/12/21.
//

import Foundation

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void)
}
