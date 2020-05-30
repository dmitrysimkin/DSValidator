//
//  MockValueValidator.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 3/22/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

final class MockValueValidator: ValueValidator {
    var property: Property
    var delegate: ErrorMessagesDelegate?
    var validations = [Validation]()
    var order: Int = 0
    var localizedName: String

    init(property: Property) {
        self.property = property
        self.localizedName = property
    }

    func required() -> ValueValidator { fatalError() }
    func notEmpty() -> ValueValidator { fatalError() }
    func localizedName(_ name: String) -> ValueValidator { fatalError() }
    func order(_ order: Int) -> ValueValidator { fatalError() }
    func when(condition: @escaping ValidationCondition) -> ValueValidator { fatalError() }
    func forScenarios(_ scenarios: [Scenario]) -> ValueValidator { fatalError() }
    func equal<T>(_ to: T) -> ValueValidator where T : Equatable { fatalError() }
    func notEqualErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func requiredErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func emptyErrorMessage(_ message: String) -> ValueValidator { fatalError() }

    var validateHook: ((Any?) -> ValidationError?)?
    func setValidateHook(_ hook: @escaping (Any?) -> ValidationError?) -> ValueValidator {
        validateHook = hook
        return self
    }

    func validate(value: Any?, scenario: Scenario?) -> ValidationError? {
        return validateHook?(value)
    }

    var validateAllHook: ((Any?) -> [ValidationError]?)?
    func setValidateAllHook(_ hook: @escaping (Any?) -> [ValidationError]?) -> ValueValidator {
        validateAllHook = hook
        return self
    }

    func validateAll(value: Any?, scenario: Scenario?) -> [ValidationError] {
        return validateAllHook?(value) ?? [ValidationError]()
    }

    func addValidation(named: String, block: @escaping ValidationBlock) -> ValueValidator { fatalError() }
    func setErrorMessage(_ message: String, for code: ValidationError.Code) -> ValueValidator { fatalError() }

    // Date
    func earlierThan(_ date: DSDate) -> ValueValidator { fatalError() }
    func notEarlierThenErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func laterThan(_ date: DSDate) -> ValueValidator { fatalError() }
    func notLaterThanErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func earlierOrEqualTo(_ date: DSDate) -> ValueValidator { fatalError() }
    func notEarlierOrEqualToErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func laterOrEqualTo(_ date: DSDate) -> ValueValidator { fatalError() }
    func notLaterOrEqualToErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func betweenDates(_ fromDate: DSDate, _ toDate: DSDate) -> ValueValidator { fatalError() }
    func betweenDatesNotIncluding(_ fromDate: DSDate, _ toDate: DSDate) -> ValueValidator { fatalError() }
    func notBetweenDatesErrorMessage(_ message: String) -> ValueValidator { fatalError() }

    // String
    func length(from length: Int) -> ValueValidator { fatalError() }
    func lengthNotFromErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func length(upTo length: Int) -> ValueValidator { fatalError() }
    func lengthNotUpToErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func length(exact length: Int) -> ValueValidator { fatalError() }
    func lengthNoExactErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func length(from: Int, to: Int) -> ValueValidator { fatalError() }
    func lengthNotFromToErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func match(_ string: String) -> ValueValidator { fatalError() }
    func notMatchErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func differ(_ string: String) -> ValueValidator { fatalError() }
    func notDifferErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func decimal() -> ValueValidator { fatalError() }
    func notDecimalErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func hasEmoji() -> ValueValidator { fatalError() }
    func noEmojiErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func hasNoEmoji() -> ValueValidator { fatalError() }
    func hasEmojiErrorMessage(_ message: String) -> ValueValidator { fatalError() }

    // Syntax
    func syntax(_ syntax: DSSyntax) -> ValueValidator { fatalError() }
    func regex(_ pattern: String, options: NSRegularExpression.Options) -> ValueValidator { fatalError() }
    func wrongSyntaxErrorMessage(_ syntax: DSSyntax, message: String) -> ValueValidator { fatalError() }
    func wrongRegexpErrorMessage(_ message: String) -> ValueValidator { fatalError() }

    // Number
    func greaterThan(_ limit: DSNumber) -> ValueValidator { fatalError() }
    func greaterThanOrEqual(_ limit: DSNumber) -> ValueValidator { fatalError() }
    func smallerThan(_ limit: DSNumber) -> ValueValidator { fatalError() }
    func smallerThanOrEqual(_ limit: DSNumber) -> ValueValidator { fatalError() }
    func `true`() -> ValueValidator { fatalError() }
    func `false`() -> ValueValidator { fatalError() }
    func notGreaterThanErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func notGreaterThanOrEqualErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func notSmallerThanErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func notSmallerThanOrEqualErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func notTrueErrorMessage(_ message: String) -> ValueValidator { fatalError() }
    func notFalseErrorMessage(_ message: String) -> ValueValidator { fatalError() }
}
