//
//  DSValueValidator+Date.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 3/1/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

private struct Names {
    static let earlierThen = "Earlier Than"
    static let laterThen = "Later Than"

    static let earlierOrEqualTo = "Earlier or equal to"
    static let laterOrEqualTo = "Later or equal to"

    static let betweenDates = "Between dates"
    static let betweenDatesNotIncluding = "Between dates not including"
}

protocol DateValueValidator {
    @discardableResult func earlierThan(_ date: DSDate) -> ValueValidator
    @discardableResult func notEarlierThenErrorMessage(_ message: String) -> ValueValidator

    @discardableResult func laterThan(_ date: DSDate) -> ValueValidator
    @discardableResult func notLaterThanErrorMessage(_ message: String) -> ValueValidator

    @discardableResult func earlierOrEqualTo(_ date: DSDate) -> ValueValidator
    @discardableResult func notEarlierOrEqualToMessage(_ message: String) -> ValueValidator

    @discardableResult func laterOrEqualTo(_ date: DSDate) -> ValueValidator
    @discardableResult func notLaterOrEqualToMessage(_ message: String) -> ValueValidator

    @discardableResult func betweenDates(_ fromDate: DSDate, _ toDate: DSDate) -> ValueValidator
    @discardableResult func betweenDatesNotIncluding(_ fromDate: DSDate, _ toDate: DSDate) -> ValueValidator
    @discardableResult func notBetweenDatesMessage(_ message: String) -> ValueValidator
}

extension ValueValidator {
    private func isDate(from value: Any?) -> Date? {
        guard let date = value as? DSDate else { return nil }
        return date.value()
    }

    // earlierThan
    @discardableResult func earlierThan(_ date: DSDate) -> ValueValidator {
        addRule(with: Names.earlierThen) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isDate(from: value) else { return .wrongType }
            return value < date.value() ? nil : .notEarlierThan
        }
    }

    @discardableResult func notEarlierThenErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notEarlierThan)
    }

    // laterThan
    @discardableResult func laterThan(_ date: DSDate) -> ValueValidator {
        addRule(with: Names.laterThen) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isDate(from: value) else { return .wrongType }
            return value > date.value() ? nil : .notLaterThan
        }
    }

    @discardableResult func notLaterThanErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notLaterThan)
    }

    // earlierOrEqualTo
    @discardableResult func earlierOrEqualTo(_ date: DSDate) -> ValueValidator {
        addRule(with: Names.earlierOrEqualTo) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isDate(from: value) else { return .wrongType }
            return value <= date.value() ? nil : .notEarlierThanOrEqualTo
        }
    }

    @discardableResult func notEarlierOrEqualToMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notEarlierThanOrEqualTo)
    }

    // laterOrEqualTo
    @discardableResult func laterOrEqualTo(_ date: DSDate) -> ValueValidator {
        addRule(with: Names.laterOrEqualTo) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isDate(from: value) else { return .wrongType }
            return value >= date.value() ? nil : .notLaterThanOrEqualTo
        }
    }

    @discardableResult func notLaterOrEqualToMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notLaterThanOrEqualTo)
    }

    // betweenDates
    @discardableResult func betweenDates(_ fromDate: DSDate, _ toDate: DSDate) -> ValueValidator {
        addRule(with: Names.betweenDates) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isDate(from: value) else { return .wrongType }
            let fromDateValue = fromDate.value(), toDateValue = toDate.value()
            guard fromDateValue < toDateValue else { return .invalidArgument }
            let result = value >= fromDateValue && value <= toDateValue
            return result ? nil : .notBetweenDates
        }
    }

    @discardableResult func betweenDatesNotIncluding(_ fromDate: DSDate, _ toDate: DSDate) -> ValueValidator {
        addRule(with: Names.betweenDatesNotIncluding) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isDate(from: value) else { return .wrongType }
            let fromDateValue = fromDate.value(), toDateValue = toDate.value()
            guard fromDateValue < toDateValue else { return .invalidArgument }
            let result = value > fromDateValue && value < toDateValue
            return result ? nil : .notBetweenDates
        }
    }

    @discardableResult func notBetweenDatesMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notBetweenDates)
    }
}

protocol DSDate {
    func value() -> Date
}

extension Date: DSDate {
    func value() -> Date { return self }
}

extension TimeInterval: DSDate {
    func value() -> Date {
        let date = Date(timeIntervalSince1970: self)
        return date
    }
}
