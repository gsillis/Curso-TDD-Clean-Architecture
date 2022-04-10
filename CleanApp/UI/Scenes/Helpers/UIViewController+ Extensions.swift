//
//  UIViewController+ Extensions.swift
//  UI
//
//  Created by Gabriela Sillis on 07/04/22.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTap() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
