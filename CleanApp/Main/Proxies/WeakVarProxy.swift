//
//  WeakVarProxy.swift
//  Main
//
//  Created by Gabriela Sillis on 12/04/22.
//

import Foundation
import PresentationLayer

class WeakVarProxy<T: AnyObject> {
    private weak var instance: T?
    
    init(instance: T) {
        self.instance = instance
    }
}

extension WeakVarProxy: AlertView where T: AlertView {
    func showMessage(viewModel: AlertViewModel) {
        instance?.showMessage(viewModel: viewModel)
    }
}

extension WeakVarProxy: LoadingView where T: LoadingView {
    func show(viewModel: LoadingViewModel) {
        instance?.show(viewModel: viewModel)
    }
}
