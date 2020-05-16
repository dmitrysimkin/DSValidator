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

    var name: String
    private(set) var rules = [Rule]()

    var delegate: ErrorMessagesDelegate?
    var defaultMessagesProvder: ErrorMessagesDelegate
    private var errorMessages = [ValidationError.Code: String]()

    init(name: String, defaultMessagesProvder: ErrorMessagesDelegate = DSDefaultMessagesProvider()) {
        self.name = name
        self.localizedName = name
        self.defaultMessagesProvder = defaultMessagesProvder
    }

    private var isRequired = false
    @discardableResult
    func required() -> ValueValidator {
        isRequired = true
        let rule = DSRule(name: Names.Required) { (value) -> ValidationError.Code? in
            guard let _ = value else { return .required }
            return nil
        }
        rules.append(rule)
        return self
    }

    private var shouldAllowEmpty = true
    @discardableResult
    func notEmpty() -> ValueValidator {
        shouldAllowEmpty = false
        let rule = DSRule(name: Names.NotEmpty) { [weak self] (value) -> ValidationError.Code? in
            guard let self = self else { return nil }
            if (self.isRequired && value == nil) { return nil } // skip if required but nil
            guard let value = value else { return nil } // skip if not required and nil
            guard let isEmpty = self.isEmpty(value) else { return .wrongType } // not applicable to be empty, e.g. Int
            return isEmpty ? .empty : nil
        }
        rules.append(rule)
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

    // MARK: - Validation

    func validate(value: Any?, scenario: Scenario? = nil) -> ValidationError? {
        guard shouldValidate(condition: condition, scenario: scenario, scenarios: scenarios) else {
            return nil
        }
        for rule in rules {
            if let errorCode = rule.validationBlock(value) {
                let error = buildError(with: errorCode, valueName: self.name)
                return error
            }
        }
        return nil
    }

    func validateAll(value: Any?, scenario: Scenario? = nil) -> [ValidationError] {
        var errors = [ValidationError]()
        guard shouldValidate(condition: condition, scenario: scenario, scenarios: scenarios) else {
            return errors
        }
        for rule in rules {
            if let errorCode = rule.validationBlock(value) {
                let error = buildError(with: errorCode, valueName: self.name)
                errors.append(error)
            }
        }
        return errors
    }
}

extension DSValueValidator: CustomValidation {
    @discardableResult
    func addRule(with name: String, block: @escaping (Any?) -> ValidationError.Code?) -> ValueValidator {
        let rule = DSRule(name: name) { [weak self] (value) -> ValidationError.Code? in
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
        self.rules.append(rule)
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

    private func buildError(with code: ValidationError.Code, valueName: String) -> ValidationError {
        // single custom message first if set
        if let message = self.errorMessages[code] {
            return ValidationError(code, message: message)
        }
        // then ask delegate for a message if provided
        if let delegate = self.delegate, let message = delegate.errorMessageByCode(code, for: valueName) {
            return ValidationError(code, message: message)
        }

        // use default messages
        let name = localizedName.capitalized
        let defaultMessage = defaultMessagesProvder.errorMessageByCode(code, for: name)
        return ValidationError(code, message: defaultMessage)
    }
}

private struct Names {
    static let Required = "Required"
    static let NotEmpty = "NotEmpty"
}
