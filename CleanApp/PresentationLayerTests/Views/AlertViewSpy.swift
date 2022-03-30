//
//  AlertViewSpy.swift
//  PresentationLayerTests
//
//  Created by Gabriela Sillis on 30/03/22.
//

import Foundation
import PresentationLayer

class AlertViewSpy: AlertView {
    var emit: ((AlertViewModel) -> Void)?
    
    func observer(completion: @escaping (AlertViewModel) -> Void) {
        emit = completion
    }
    
    func showMessage(viewModel: AlertViewModel) {
        self.emit?(viewModel)
    }
}
