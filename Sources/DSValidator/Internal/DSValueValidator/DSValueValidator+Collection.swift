//
//  DSValueValidator+Collection.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/30/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

extension ValueValidator {

    @discardableResult func includes<T: Equatable>(_ element: T) -> ValueValidator {
        addValidation(named: Names.includes) { (value) -> ValidationError.Code? in
            guard let anyCollection = value as? DSCollection else { return .wrongType }
            let result = anyCollection.includes(element)
            return result ? nil : .notIncludes
        }
    }

    @discardableResult func excludes<T: Equatable>(_ element: T) -> ValueValidator {
        addValidation(named: Names.excludes) { (value) -> ValidationError.Code? in
            guard let anyCollection = value as? DSCollection else { return .wrongType }
            let result = anyCollection.includes(element)
            return result == false ? nil : .notExcludes
        }
    }

    @discardableResult func includedIn(_ collection: DSCollection) -> ValueValidator {
        addValidation(named: Names.includedIn) { (value) -> ValidationError.Code? in
            let result = collection.includes(value)
            return result ? nil : .notIncludedIn
        }
    }

    @discardableResult func excludedFrom(_ collection: DSCollection) -> ValueValidator {
        addValidation(named: Names.excludedFrom) { (value) -> ValidationError.Code? in
            let result = collection.includes(value)
            return result == false ? nil : .notExcludedFrom
        }
    }

    @discardableResult func notIncludesErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notIncludes)
    }

    @discardableResult func notExcludesErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notExcludes)
    }

    @discardableResult func notIncludedInErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notIncludedIn)
    }

    @discardableResult func notExcludedFromErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notExcludedFrom)
    }
}

private struct Names {
    static let includes = "Includes"
    static let excludes = "Excludes"
    static let includedIn = "IncludedIn"
    static let excludedFrom = "ExcludedFrom"
}
