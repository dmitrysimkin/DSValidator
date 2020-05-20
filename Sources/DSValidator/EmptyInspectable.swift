//
//  EmptyInspectable.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 3/9/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

protocol EmptyInspectable {
    func isEmpty() -> Bool?
}

struct AnyEmptyInspectable: EmptyInspectable {
    func isEmpty() -> Bool? {
        guard let value = wrapped as? EmptyInspectable else { return nil }
        let result = value.isEmpty()
        return result
    }

    let wrapped: Any
    init(_ wrapped: Any) {
        self.wrapped = wrapped
    }
}

extension Dictionary: EmptyInspectable {
    func isEmpty() -> Bool? {
        return self.keys.count == 0
    }
}

extension Set: EmptyInspectable {
    func isEmpty() -> Bool? {
        return self.count == 0
    }
}

extension String: EmptyInspectable {
    func isEmpty() -> Bool? {
        return self.count == 0
    }
}

extension Data: EmptyInspectable {
    func isEmpty() -> Bool? {
        return self.count == 0
    }
}

extension Array: EmptyInspectable {
    func isEmpty() -> Bool? {
        return self.count == 0
    }
}

//extension Optional: EmptyInspectable {
//    func isEmpty() -> Bool? {
//        switch self {
//        case .none:
//            return false
//        case .some(let wrapped):
//            guard let value = wrapped as? EmptyInspectable else { return nil }
//            let result = value.isEmpty()
//            return result
//        }
//    }
//}
