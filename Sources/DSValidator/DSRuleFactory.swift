//
//  DSRuleFactory.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/22/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

/// Type representing model's property name to validate
public typealias Property = String

/// Factory to easily create rules
public class DS {
    /// Default property name
    private static let defaultPropertyName = "Value"

    /**
     Creates rule not tied to model's property.
     Should be used for single value validation, not for models
     - Parameters:
        - messagesProvider: Provider to drive error messages by error code
     - Returns: `ValueValidator` to pass to `DSValidator`
     # Example #
     ```
     let rule = DS.rule().required().length(exact: 4)
     let errors = DSValidator.validate(value: "Test", rule: rule)
     ```
     */
    public static func rule(messagesProvider: ErrorMessagesDelegate = DSDefaultMessagesProvider()) -> ValueValidator {
        return DSValueValidator(property: DS.defaultPropertyName, defaultMessagesProvider: messagesProvider)
    }

    /**
     Creates rule for model's property.
     - Parameters:
        - property: Model's property to validate
        - messagesProvider: Provider to drive error messages by error code.
     - Returns: `ValueValidator` to pass to `DSValidator`
     # Example #
     ```
     let errors = DSValidator.validate(model: model) {
         [DS.rule(for: "age").required().greaterThan(18),
          DS.rule(for: "username").required().notEmpty().length(from: 3, to: 20)]
     }
     ```
     */
    public static func rule(for property: Property,
                            messagesProvider: ErrorMessagesDelegate = DSDefaultMessagesProvider()) -> ValueValidator {
        return DSValueValidator(property: property, defaultMessagesProvider: messagesProvider)
    }
}
