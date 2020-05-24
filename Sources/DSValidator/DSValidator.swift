//
//  DSValidator.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 3/20/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation


public typealias Rules = () -> [ValueValidator]
public typealias Scenario = String

public final class DSValidator {

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
