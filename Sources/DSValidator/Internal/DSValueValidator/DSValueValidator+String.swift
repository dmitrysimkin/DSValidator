//
//  DSValueValidator+String.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/30/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

extension DSValueValidator {
    func isString(from value: Any?) -> String? {
        guard let string = value as? String else { return nil }
        return string
    }

    @discardableResult func length(from length: Int) -> ValueValidator {
        addValidation(named: Names.lengthFrom) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            return value.count >= length ? nil : .lengthNotFrom
        }
    }

    @discardableResult func lengthNotFromErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .lengthNotFrom)
    }

    @discardableResult func length(upTo length: Int) -> ValueValidator {
        addValidation(named: Names.lengthUpTo) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            return value.count <= length ? nil : .lengthNotUpTo
        }
    }

    @discardableResult func lengthNotUpToErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .lengthNotUpTo)
    }

    @discardableResult func length(exact length: Int) -> ValueValidator {
        addValidation(named: Names.lengthExact) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            return value.count == length ? nil : .lengthNotExact
        }
    }

    @discardableResult func lengthNoExactErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .lengthNotExact)
    }

    @discardableResult func length(from: Int, to: Int) -> ValueValidator {
        addValidation(named: Names.lengthFromTo) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            guard from <= to else { return .invalidArgument }
            return (value.count >= from && value.count <= to) ? nil : .lengthNotFromTo
        }
    }

    @discardableResult func lengthNotFromToErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .lengthNotFromTo)
    }

    @discardableResult func match(_ string: String) -> ValueValidator {
        addValidation(named: Names.match) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            return string == value ? nil : .notMatch
        }
    }

    @discardableResult func notMatchErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notMatch)
    }

    @discardableResult func differ(_ string: String) -> ValueValidator {
        addValidation(named: Names.differ) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            return string != value ? nil : .notDiffer
        }
    }

    @discardableResult func notDifferErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notDiffer)
    }

    @discardableResult func decimal() -> ValueValidator {
        addValidation(named: Names.decimal) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            return value.isDecimal ? nil : .notDecimal
        }
    }

    @discardableResult func notDecimalErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notDecimal)
    }

    @discardableResult func hasEmoji() -> ValueValidator {
        addStringRule(with: Names.hasEmoji) { (value) -> ValidationError.Code? in
            return value.hasEmoji ? nil : .noEmoji
        }
    }

    @discardableResult func hasNoEmoji() -> ValueValidator {
        addStringRule(with: Names.hasNoEmoji) { (value) -> ValidationError.Code? in
            return value.hasNoEmoji ? nil : .hasEmoji
        }
    }

    @discardableResult func noEmojiErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .noEmoji)
    }

    func hasEmojiErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .hasEmoji)
    }
}

private struct Names {
    static let lengthFrom = "Length from"
    static let lengthUpTo = "Length up to"

    static let lengthExact = "Length exact"
    static let lengthFromTo = "Lenght from to"

    static let match = "Match"
    static let differ = "Differ"

    static let decimal = "Decimal"

    static let hasEmoji = "Has emoji"
    static let hasNoEmoji = "Has emoji"
}
