//
//  DSValidator.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 3/20/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

typealias Rules = () -> [ValueValidator]

final class DSValidator {

    static func validate(object: Any,
                         tillFirstError: Bool = false,
                         delegate: ErrorMessagesDelegate? = nil,
                         scenario: String? = nil,
                         rules: Rules) -> [ValidationError] {

        let validators = rules().sorted(by: { $0.order > $1.order })

        let reflection = Reflection(of: object)
        guard reflection.isSupportedType() else {
            return [ValidationError.objectOfNotSupportedType()]
        }

        let properties = reflection.properties()
        var errors: [ValidationError] = []

        for validator in validators {
            validator.delegate = delegate

            guard properties.contains(validator.name) else {
                let error = ValidationError.valueNotFound()
                if tillFirstError {
                    return [error]
                }
                errors.append(error)
                continue
            }

            let value = reflection.value(withKey: validator.name)

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

    static func validate(value: Any?,
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
