//
//  NavigationController.swift
//  UI
//
//  Created by Gabriela Sillis on 25/05/22.
//

import UIKit

public final class NavigationController: UINavigationController {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        fatalError("init(coder:) has not been implemented")
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    private func setup() {
        navigationBar.barTintColor = Color.primaryDark
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.isTranslucent = false
        navigationBar.barStyle = .black
        navigationBar.backgroundColor = Color.primaryDark
    }
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    public func setRootViewControllers(_ viewController: UIViewController) {
        setViewControllers([viewController], animated: true)
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
    
    public func pushViewController(_ viewController: UIViewController) {
        pushViewController(viewController, animated: true)
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
}
