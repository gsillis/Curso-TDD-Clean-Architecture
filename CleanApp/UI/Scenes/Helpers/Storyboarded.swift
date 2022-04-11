//
//  Storyboarded.swift
//  UI
//
//  Created by Gabriela Sillis on 09/04/22.
//

import UIKit
import Foundation

public protocol Storyboarded {
    static func instantiate() -> Self
}

public extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let vcName = String(describing: self)
        let sbName = vcName.components(separatedBy: "ViewController")[0]
        let bunble = Bundle(for: Self.self)
        let sb = UIStoryboard(name: sbName, bundle: bunble)
        return sb.instantiateViewController(withIdentifier: vcName) as! Self
    }
}
