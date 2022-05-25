//
//  NavigationController.swift
//  UI
//
//  Created by Gabriela Sillis on 25/05/22.
//

import UIKit

public final class NavigationController: UINavigationController {

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        navigationBar.barTintColor = Color.primaryDark
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.isTranslucent = false
        navigationBar.barStyle = .black
        navigationBar.backgroundColor = Color.primaryDark
    }
}
