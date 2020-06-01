//
//  DSValueValidator.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/25/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

let DSValidatorDefaultOrder = 500

final class DSValueValidator: ValueValidator {

    var property: String
    private(set) var validations = [Validation]()

    var delegate: ErrorMessagesDelegate?
    var defaultMessagesProvider: ErrorMessagesDelegate
    private var errorMessages = [ValidationError.Code: String]()

    init(property: Property, defaultMessagesProvider: ErrorMessagesDelegate? = nil) {
        self.property = property
        self.localizedName = property
        self.defaultMessagesProvider = defaultMessagesProvider ?? DSDefaultMessagesProvider()
    }

    @discardableResult func equal<T: Equatable>(to: T) -> ValueValidator {
        let validation = DSValidation(name: Names.equal) { (value) -> ValidationError.Code? in
            let result: ValidationError.Code?
            if let equatable = value as? T {
                result = equatable == to ? nil : .notEqual
            } else if let numberValue = value as? DSNumber,
                let equalToNumberValue = to as? DSNumber {
                result = DSAnyNumber(numberValue) == DSAnyNumber(equalToNumberValue) ? nil : .notEqual
            } else {
                return .wrongType
            }
            return result
        }
        validations.append(validation)
        return self
    }

    private var isRequired = false
    @discardableResult
    func required() -> ValueValidator {
        isRequired = true
        let validation = DSValidation(name: Names.Required) { (value) -> ValidationError.Code? in
            guard let _ = value else { return .required }
            return nil
        }
        validations.append(validation)
        return self
    }

    private var shouldAllowEmpty = true
    @discardableResult
    func notEmpty() -> ValueValidator {
        shouldAllowEmpty = false
        let validation = DSValidation(name: Names.NotEmpty) { [weak self] (value) -> ValidationError.Code? in
            guard let self = self else { return nil }
            if (self.isRequired && value == nil) { return nil } // skip if required but nil
            guard let value = value else { return nil } // skip if not required and nil
            guard let isEmpty = self.isEmpty(value) else { return .wrongType } // not applicable to be empty, e.g. Int
            return isEmpty ? .empty : nil
        }
        validations.append(validation)
        return self
    }

    var localizedName: String
    @discardableResult
    func localizedName(_ name: String) -> ValueValidator {
        self.localizedName = name
        return self
    }

    var order = DSValidatorDefaultOrder
    @discardableResult
    func order(_ order: Int) -> ValueValidator {
        self.order = order
        return self
    }

    private var scenarios = [Scenario]()
    @discardableResult
    func forScenarios(_ scenarios: [Scenario]) -> ValueValidator {
        self.scenarios = scenarios
        return self
    }

    private var condition: ValidationCondition?
    @discardableResult
    func when(condition: @escaping ValidationCondition) -> ValueValidator {
        self.condition = condition
        return self
    }

    @discardableResult func requiredErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .required)
    }

    @discardableResult func emptyErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .empty)
    }

    @discardableResult func notEqualErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notEqual)
    }

    // MARK: - Validation

    func validate(value: Any?, scenario: Scenario? = nil) -> ValidationError? {
        let errors = validate(value: value, tillFirstError: true, scenario: scenario)
        return errors.first
    }

    func validate(value: Any?, tillFirstError: Bool = false, scenario: Scenario? = nil) -> [ValidationError] {
        var errors = [ValidationError]()
        guard shouldValidate(condition: condition, scenario: scenario, scenarios: scenarios) else {
            return errors
        }
        for validation in validations {
            if let errorCode = validation.block(value) {
                let error = buildError(with: errorCode, property: self.property)
                errors.append(error)
                if tillFirstError {
                    break
                }
            }
        }
        return errors
    }
}

extension DSValueValidator: CustomValidation {
    @discardableResult
    func addValidation(named: String, block: @escaping (Any?) -> ValidationError.Code?) -> ValueValidator {
        let validation = DSValidation(name: property) { [weak self] (value) -> ValidationError.Code? in
            guard let self = self else { return nil }
            // skip if requred, because required validation already should return error
            if self.isRequired, value == nil { return nil }
            guard let value = value else { return nil }
            // check if empty and skip validation if it is
            if self.shouldAllowEmpty == false, let isEmpty = self.isEmpty(value), isEmpty == true {
                return nil
            }
            return block(value)
        }
        self.validations.append(validation)
        return self
    }

    @discardableResult
    func setErrorMessage(_ message: String, for code: ValidationError.Code) -> ValueValidator {
        errorMessages[code] = message
        return self
    }
}

// MARK: - Internal

extension DSValueValidator {

    private func shouldValidate(condition: ValidationCondition?,
                                scenario: Scenario?, scenarios: [Scenario]) -> Bool {
        if let condition = condition, condition() == false {
            return false
        }
        if let scenario = scenario {
            let shouldValidate = scenarios.contains(scenario)
            return shouldValidate
        }
        return true
    }

    private func isEmpty(_ value: Any) -> Bool? {
        let wrapped = AnyEmptyInspectable(value)
        let result = wrapped.isEmpty()
        return result
    }

    private func buildError(with code: ValidationError.Code, property: String) -> ValidationError {
        // single custom message first if set
        if let message = self.errorMessages[code] {
            return ValidationError(code, message: message)
        }
        // then ask delegate for a message if provided
        if let delegate = self.delegate, let message = delegate.errorMessage(by: code, for: property) {
            return ValidationError(code, message: message)
        }

        // use default messages
        let name = localizedName.capitalized
        let defaultMessage = defaultMessagesProvider.errorMessage(by: code, for: name)
        return ValidationError(code, message: defaultMessage)
    }
}

private struct Names {
    static let Required = "Required"
    static let NotEmpty = "NotEmpty"
    static let equal = "Equal"
}
