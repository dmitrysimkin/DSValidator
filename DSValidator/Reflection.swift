//
//  Mirroring.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 3/20/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

@objc final class Reflection: NSObject {

    private let object: Any

    private var mirror: Mirror {
        return Mirror(reflecting: object)
    }

    init(of object: Any) {
        self.object = object
    }

    func properties() -> [String] {
        return mirror.properties()
    }

    func value(withKey key: String) -> Any? {
        let value = mirror.value(forKey: key)
        return value
    }

    func isSupportedType() -> Bool {
        switch mirror.displayStyle {
        case .struct, .class:
            return true
        default:
            return false
        }
    }
}

fileprivate extension Mirror {
    func value(forKey key: String) -> Any? {
        if let value = children.filter({ $0.label == key }).first?.value {
            let valueMirror = Mirror(reflecting: value)
            guard valueMirror.displayStyle == .optional else {
                // just return value if not optional
                return value
            }

            guard let (_, some) = valueMirror.children.first else {
                // optioanl value containing nil, return just nil
                return nil
            }
            // optinal value containing some, return value it's containing
            return some
        }
        return superclassMirror?.value(forKey: key)
    }

    func properties() -> [String] {
        let childProperties = children.compactMap { $0.label }
        let superProperties = superclassMirror?.properties() ?? []

        return [childProperties, superProperties].flatMap { $0 }
    }
}
