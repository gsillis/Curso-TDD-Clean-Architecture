//
//  LoadingViewSpy.swift
//  PresentationLayerTests
//
//  Created by Gabriela Sillis on 30/03/22.
//

import Foundation
import PresentationLayer

class LoadingViewSpy: LoadingView {
    var emit: ((LoadingViewModel) -> Void)?
    
    func observer(completion: @escaping (LoadingViewModel) -> Void) {
        emit = completion
    }
    
    func show(viewModel: LoadingViewModel) {
        emit?(viewModel)
    }
}
