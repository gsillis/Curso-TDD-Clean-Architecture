//
//  Test+Extensions.swift
//  UITests
//
//  Created by Gabriela Sillis on 07/04/22.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach({ action in
                (target as NSObject).perform(Selector(action))
            })
        }
    }
    
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
