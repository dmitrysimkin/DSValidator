//
//  DSCollection+Extensions.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/17/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

extension Array: DSCollection where Array.Element: Equatable {
    public func includes(_ object: Any?) -> Bool {
        guard let object = object as? Element else { return false }
        let result = contains(object)
        return result
    }
}

extension Set: DSCollection {
    public func includes(_ object: Any?) -> Bool {
        guard let object = object as? Element else { return false }
        let result = contains(object)
        return result
    }
}
