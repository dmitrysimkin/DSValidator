//
//  DSValueValidator+Number.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/30/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

extension DSValueValidator {
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

    @discardableResult func notGreaterThanErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notGreater)
    }

    @discardableResult func notGreaterThanOrEqualErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notGreaterOrEqual)
    }

    @discardableResult func notSmallerThanErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notSmaller)
    }

    @discardableResult func notSmallerThanOrEqualErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notSmallerOrEqual)
    }

    @discardableResult func notTrueErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notTrue)
    }

    @discardableResult func notFalseErrorMessage(_ message: String) -> ValueValidator {
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
