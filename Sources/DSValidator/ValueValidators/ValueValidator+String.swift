//
//  DSValueValidator+String.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 3/14/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation


public protocol StringValueValidator {
    // including
    @discardableResult func length(from length: Int) -> ValueValidator
    @discardableResult func lengthNotFromMessage(_ message: String) -> ValueValidator

    // including
    @discardableResult func length(upTo length: Int) -> ValueValidator
    @discardableResult func lengthNotUpToMessage(_ message: String) -> ValueValidator

    @discardableResult func length(exact length: Int) -> ValueValidator
    @discardableResult func lengthNoExactMessage(_ message: String) -> ValueValidator

    // including
    @discardableResult func length(from: Int, to: Int) -> ValueValidator
    @discardableResult func lengthNotFromToMessage(_ message: String) -> ValueValidator

    @discardableResult func match(_ string: String) -> ValueValidator
    @discardableResult func notMatchMessage(_ message: String) -> ValueValidator

    @discardableResult func differ(_ string: String) -> ValueValidator
    @discardableResult func notDifferMessage(_ message: String) -> ValueValidator

    @discardableResult func decimal() -> ValueValidator
    @discardableResult func notDecimalMessage(_ message: String) -> ValueValidator

    @discardableResult func hasEmoji() -> ValueValidator
    @discardableResult func noEmojiMessage(_ message: String) -> ValueValidator

    @discardableResult func hasNoEmoji() -> ValueValidator
    @discardableResult func hasEmojiMessage(_ message: String) -> ValueValidator
}

extension ValueValidator {
    func isString(from value: Any?) -> String? {
        guard let string = value as? String else { return nil }
        return string
    }

    @discardableResult func length(from length: Int) -> ValueValidator {
        addRule(with: Names.lengthFrom) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            return value.count >= length ? nil : .lengthNotFrom
        }
    }

    @discardableResult func lengthNotFromMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .lengthNotFrom)
    }

    @discardableResult func length(upTo length: Int) -> ValueValidator {
        addRule(with: Names.lengthUpTo) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            return value.count <= length ? nil : .lengthNotUpTo
        }
    }

    @discardableResult func lengthNotUpToMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .lengthNotUpTo)
    }

    @discardableResult func length(exact length: Int) -> ValueValidator {
        addRule(with: Names.lengthExact) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            return value.count == length ? nil : .lengthNotExact
        }
    }

    @discardableResult func lengthNoExactMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .lengthNotExact)
    }

    @discardableResult func length(from: Int, to: Int) -> ValueValidator {
        addRule(with: Names.lengthFromTo) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            guard from <= to else { return .invalidArgument }
            return (value.count >= from && value.count <= to) ? nil : .lengthNotFromTo
        }
    }

    @discardableResult func lengthNotFromToMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .lengthNotFromTo)
    }

    @discardableResult func match(_ string: String) -> ValueValidator {
        addRule(with: Names.match) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            return string == value ? nil : .notMatch
        }
    }

    @discardableResult func notMatchMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notMatch)
    }

    @discardableResult func differ(_ string: String) -> ValueValidator {
        addRule(with: Names.differ) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            return string != value ? nil : .notDiffer
        }
    }

    @discardableResult func notDifferMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notDiffer)
    }

    @discardableResult func decimal() -> ValueValidator {
        addRule(with: Names.decimal) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            return value.isDecimal ? nil : .notDecimal
        }
    }

    @discardableResult func notDecimalMessage(_ message: String) -> ValueValidator {
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

    @discardableResult func noEmojiMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .noEmoji)
    }

    func hasEmojiMessage(_ message: String) -> ValueValidator {
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
