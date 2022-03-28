//
//  LoadingView.swift
//  PresentationLayer
//
//  Created by Gabriela Sillis on 28/03/22.
//

import Foundation

public protocol LoadingView {
    func show(viewModel: LoadingViewModel)
}

public struct LoadingViewModel: Equatable {
    public var isLoading: Bool?
    
    public init(isLoading: Bool?) {
        self.isLoading = isLoading
    }
}
