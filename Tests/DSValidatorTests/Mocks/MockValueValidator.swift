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
    func notEqualMessage(_ message: String) -> ValueValidator {
        return self
    }

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
}
