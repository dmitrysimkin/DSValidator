//
//  DSValidator.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 3/20/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

/// Array of rules
public typealias Rules = () -> [ValueValidator]
/// Scenario to validate against
public typealias Scenario = String

/// Main class to validate objects
/// Can validate custom models (classes and structs) and single values (Int, String, Date, Array, etc)
public final class DSValidator {

    /**
     Validates some arbitrary model with rules you provide

     # Limitation
     **Computed properties not supported, only model's stored properties can be validated**

     - Parameters:
        - model: Model to validate
        - tillFirstError: Stop validation when first error found or not (to find all errors)
        - delegate: Error messages delegate to provide custom error messages
        - scenario: Particular scenario to run validation for. Only rules related to this scenarion will be executed.
        - rules: Array of rules to validate model's properties against
     - Returns: Array of errros if any, empty if validation succeeded
     # Example #
     ```
     let errors = DSValidator.validate(model: model, tillFirstError: true) {
         [DS.rule(for: "username").required().notEmpty().length(from: 3, to: 20),
          DS.rule(for: "age").required()]
     }
     ```
     */
    public static func validate(model: Any,
                                tillFirstError: Bool = false,
                                delegate: ErrorMessagesDelegate? = nil,
                                scenario: Scenario? = nil,
                                rules: Rules) -> [ValidationError] {

        let validators = rules().sorted(by: { $0.order > $1.order })

        let reflection = Reflection(of: model)
        guard reflection.isSupportedType() else {
            return [ValidationError.objectOfNotSupportedType()]
        }

        let properties = reflection.properties()
        var errors: [ValidationError] = []

        for validator in validators {
            validator.delegate = delegate

            guard properties.contains(validator.property) else {
                let error = ValidationError.valueNotFound()
                if tillFirstError {
                    return [error]
                }
                errors.append(error)
                continue
            }

            let value = reflection.value(withKey: validator.property)

            if (tillFirstError) {
                if let validationError = validator.validate(value: value, scenario: scenario) {
                    return [validationError]
                }
            } else {
                let validationErrors = validator.validateAll(value: value, scenario: scenario)
                errors.append(contentsOf: validationErrors)
            }
        }

        return errors
    }

    /**
     Validates any value with rules you provide
     - Parameters:
        - value: Value to validate
        - tillFirstError: Stop validation when first error found or not (to find all errors)
        - delegate: Error messages delegate to provide custom error messages
        - scenario: Particular scenario to run validation for. Only rules related to this scenarion will be executed.
        - rule: Rule to validate
     - Returns: Array of errros if any, empty if validation succeeded
     # Example #
     ```
     let rule = DS.rule().required().earlierThan(Date())
     let errors = DSValidator.validate(value: date, rule: rule)
     ```
     */
    public static func validate(value: Any?,
                                tillFirstError: Bool = false,
                                delegate: ErrorMessagesDelegate? = nil,
                                scenario: String? = nil,
                                rule: ValueValidator) -> [ValidationError] {
        var errors: [ValidationError] = []

        rule.delegate = delegate

        if (tillFirstError) {
            if let validationError = rule.validate(value: value, scenario: scenario) {
                return [validationError]
            }
        } else {
            let validationErrors = rule.validateAll(value: value, scenario: scenario)
            errors.append(contentsOf: validationErrors)
        }

        return errors
    }
}
