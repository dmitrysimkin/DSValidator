//
//  DSValueValidator+Number.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/2/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation


public protocol NumberValueValidator {
    @discardableResult func greaterThan(_ limit: DSNumber) -> ValueValidator
    @discardableResult func greaterThanOrEqual(_ limit: DSNumber) -> ValueValidator
    @discardableResult func smallerThan(_ limit: DSNumber) -> ValueValidator
    @discardableResult func smallerThanOrEqual(_ limit: DSNumber) -> ValueValidator
    @discardableResult func equal(_ to: DSNumber) -> ValueValidator
    @discardableResult func `true`() -> ValueValidator
    @discardableResult func `false`() -> ValueValidator

    @discardableResult func notGreaterThanMessage(_ message: String) -> ValueValidator
    @discardableResult func notGreaterThanOrEqualMessage(_ message: String) -> ValueValidator
    @discardableResult func notSmallerThanMessage(_ message: String) -> ValueValidator
    @discardableResult func notSmallerThanOrEqualMessage(_ message: String) -> ValueValidator
    @discardableResult func notEqualMessage(_ message: String) -> ValueValidator
    @discardableResult func notTrueMessage(_ message: String) -> ValueValidator
    @discardableResult func notFalseMessage(_ message: String) -> ValueValidator

}

extension ValueValidator {
    @discardableResult func greaterThan(_ limit: DSNumber) -> ValueValidator {
        addNumberRule(with: Names.greaterThan) { (number) -> ValidationError.Code? in
            let result = DSAnyNumber(number) > DSAnyNumber(limit)
            return result ? nil : .notGreater
        }
    }

    @discardableResult func greaterThanOrEqual(_ limit: DSNumber) -> ValueValidator {
        addNumberRule(with: Names.greaterThanOrEqual) { (number) -> ValidationError.Code? in
            let result = DSAnyNumber(number) >= DSAnyNumber(limit)
            return result ? nil : .notGreaterOrEqual
        }
    }

    @discardableResult func smallerThan(_ limit: DSNumber) -> ValueValidator {
        addNumberRule(with: Names.smallerThan) { (number) -> ValidationError.Code? in
            let result = DSAnyNumber(number) < DSAnyNumber(limit)
            return result ? nil : .notSmaller
        }
    }

    @discardableResult func smallerThanOrEqual(_ limit: DSNumber) -> ValueValidator {
        addNumberRule(with: Names.smallerThanOrEqual) { (number) -> ValidationError.Code? in
            let result = DSAnyNumber(number) <= DSAnyNumber(limit)
            return result ? nil : .notSmallerOrEqual
        }
    }

    @discardableResult func equal(_ to: DSNumber) -> ValueValidator {
        addNumberRule(with: Names.equal) { (number) -> ValidationError.Code? in
            let result = DSAnyNumber(number) == DSAnyNumber(to)
            return result ? nil : .notEqual
        }
    }

    func isNumber(from value: Any?) -> DSNumber? {
        guard let number = value as? DSNumber else { return nil }
        return number
    }

    @discardableResult
    func addNumberRule(with name: String, block: @escaping (DSNumber) -> ValidationError.Code?) -> ValueValidator {
        addValidation(named: name) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isNumber(from: value) else { return .wrongType }
            return block(value)
        }
    }

    @discardableResult func `true`() -> ValueValidator {
        addValidation(named: Names.true) { (value) -> ValidationError.Code? in
            guard let value = value as? Bool else { return .wrongType }
            return value == true ? nil : .notTrue
        }

    }
    @discardableResult func `false`() -> ValueValidator {
        addValidation(named: Names.false) { (value) -> ValidationError.Code? in
            guard let value = value as? Bool else { return .wrongType }
            return value == false ? nil : .notFalse
        }
    }

    @discardableResult func notGreaterThanMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notGreater)
    }

    @discardableResult func notGreaterThanOrEqualMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notGreaterOrEqual)
    }

    @discardableResult func notSmallerThanMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notSmaller)
    }

    @discardableResult func notSmallerThanOrEqualMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notSmallerOrEqual)
    }

    @discardableResult func notEqualMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notEqual)
    }

    @discardableResult func notTrueMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notTrue)
    }

    @discardableResult func notFalseMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notFalse)
    }
}

private struct Names {
    static let greaterThan = "Greater than"
    static let greaterThanOrEqual = "Greater than or equal"
    static let smallerThan = "Smaller than"
    static let smallerThanOrEqual = "Smaller than or equal"
    static let equal = "Equal"
    static let `true` = "True"
    static let `false` = "False"
}
