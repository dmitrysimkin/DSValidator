//
//  DSValueValidator+Collection.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/3/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation


public protocol CollectionValueValidator {
    @discardableResult func includes<T: Equatable>(_ element: T) -> ValueValidator
    @discardableResult func excludes<T: Equatable>(_ element: T) -> ValueValidator
    @discardableResult func includedIn(_ collection: DSCollection) -> ValueValidator
    @discardableResult func excludedFrom(_ collection: DSCollection) -> ValueValidator

    @discardableResult func notIncludesMessage(_ message: String) -> ValueValidator
    @discardableResult func notExcludesMessage(_ message: String) -> ValueValidator
    @discardableResult func notIncludedInMessage(_ message: String) -> ValueValidator
    @discardableResult func notExcludedFromMessage(_ message: String) -> ValueValidator

}

extension ValueValidator {

    @discardableResult func includes<T: Equatable>(_ element: T) -> ValueValidator {
        addRule(with: Names.includes) { (value) -> ValidationError.Code? in
            guard let anyCollection = value as? DSCollection else { return .wrongType }
            let result = anyCollection.includes(element)
            return result ? nil : .notIncludes
        }
    }

    @discardableResult func excludes<T: Equatable>(_ element: T) -> ValueValidator {
        addRule(with: Names.excludes) { (value) -> ValidationError.Code? in
            guard let anyCollection = value as? DSCollection else { return .wrongType }
            let result = anyCollection.includes(element)
            return result == false ? nil : .notExcludes
        }
    }

    @discardableResult func includedIn(_ collection: DSCollection) -> ValueValidator {
        addRule(with: Names.includedIn) { (value) -> ValidationError.Code? in
            let result = collection.includes(value)
            return result ? nil : .notIncludedIn
        }
    }

    @discardableResult func excludedFrom(_ collection: DSCollection) -> ValueValidator {
        addRule(with: Names.excludedFrom) { (value) -> ValidationError.Code? in
            let result = collection.includes(value)
            return result == false ? nil : .notExcludedFrom
        }
    }

    @discardableResult func notIncludesMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notIncludes)
    }

    @discardableResult func notExcludesMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notExcludes)
    }

    @discardableResult func notIncludedInMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notIncludedIn)
    }

    @discardableResult func notExcludedFromMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notExcludedFrom)
    }
}

private struct Names {
    static let includes = "Includes"
    static let excludes = "Excludes"
    static let includedIn = "IncludedIn"
    static let excludedFrom = "ExcludedFrom"
}
