//
//  DSValueValidator+Date.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/30/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

extension DSValueValidator {
    private func isDate(from value: Any?) -> Date? {
        guard let date = value as? DSDate else { return nil }
        return date.value()
    }

    // earlierThan
    @discardableResult func earlierThan(_ date: DSDate) -> ValueValidator {
        addValidation(named: Names.earlierThen) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isDate(from: value) else { return .wrongType }
            return value < date.value() ? nil : .notEarlierThan
        }
    }

    @discardableResult func notEarlierThenErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notEarlierThan)
    }

    // laterThan
    @discardableResult func laterThan(_ date: DSDate) -> ValueValidator {
        addValidation(named: Names.laterThen) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isDate(from: value) else { return .wrongType }
            return value > date.value() ? nil : .notLaterThan
        }
    }

    @discardableResult func notLaterThanErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notLaterThan)
    }

    // earlierOrEqualTo
    @discardableResult func earlierOrEqualTo(_ date: DSDate) -> ValueValidator {
        addValidation(named: Names.earlierOrEqualTo) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isDate(from: value) else { return .wrongType }
            return value <= date.value() ? nil : .notEarlierThanOrEqualTo
        }
    }

    @discardableResult func notEarlierOrEqualToErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notEarlierThanOrEqualTo)
    }

    // laterOrEqualTo
    @discardableResult func laterOrEqualTo(_ date: DSDate) -> ValueValidator {
        addValidation(named: Names.laterOrEqualTo) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isDate(from: value) else { return .wrongType }
            return value >= date.value() ? nil : .notLaterThanOrEqualTo
        }
    }

    @discardableResult func notLaterOrEqualToErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notLaterThanOrEqualTo)
    }

    // betweenDates
    @discardableResult func betweenDates(_ fromDate: DSDate, _ toDate: DSDate) -> ValueValidator {
        addValidation(named: Names.betweenDates) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isDate(from: value) else { return .wrongType }
            let fromDateValue = fromDate.value(), toDateValue = toDate.value()
            guard fromDateValue < toDateValue else { return .invalidArgument }
            let result = value >= fromDateValue && value <= toDateValue
            return result ? nil : .notBetweenDates
        }
    }

    @discardableResult func betweenDatesNotIncluding(_ fromDate: DSDate, _ toDate: DSDate) -> ValueValidator {
        addValidation(named: Names.betweenDatesNotIncluding) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isDate(from: value) else { return .wrongType }
            let fromDateValue = fromDate.value(), toDateValue = toDate.value()
            guard fromDateValue < toDateValue else { return .invalidArgument }
            let result = value > fromDateValue && value < toDateValue
            return result ? nil : .notBetweenDates
        }
    }

    @discardableResult func notBetweenDatesErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notBetweenDates)
    }
}

private struct Names {
    static let earlierThen = "Earlier Than"
    static let laterThen = "Later Than"

    static let earlierOrEqualTo = "Earlier or equal to"
    static let laterOrEqualTo = "Later or equal to"

    static let betweenDates = "Between dates"
    static let betweenDatesNotIncluding = "Between dates not including"
}
