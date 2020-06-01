//
//  ValueValidator.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/23/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

/// Block that represents condition when validation should be skipped
public typealias ValidationCondition = () -> Bool

/**
 Rules to validate
 */
public protocol ValueValidator:  AnyObject,
        CustomValidation,
        DateValueValidator,
        StringValueValidator,
        SyntaxValueValidator,
        NumberValueValidator,
        CollectionValueValidator {
    /// Property name to retrieve value from model and validet it
    var property: Property { get }

    /// Error messages delegate.
    /// Use when you want customize error messages instead of default ones
    var delegate: ErrorMessagesDelegate? { get set }

    /// Blocks that contain validation logic
    var validations: [Validation] { get }

    /// Order in which rules to validate
    var order: Int { get }

    /**
     Sets order in which rules execute. Rules are being sorted before validation and rules with higher order value to validate first.
     Default: 500
     - Parameters:
        - order: Order value to set
     */
    @discardableResult func order(_ order: Int) -> ValueValidator

    /// * Localized property name.
    /// * Used to build error messages. If not set, 'property' is used
    var localizedName: String { get } // TODO: Rename to property

    /// * Localized property name.
    /// * Used to build error messages. If not set, 'property' is used
    @discardableResult func localizedName(_ name: String) -> ValueValidator // TODO: Rename to property

    /**
     Value has to be not nil.
     - Note: If *required()* rule is not set but value is *nil* then any rule is skipped
     - Returns: `ValidationError.Code.required` if validation fails
     */
    @discardableResult func required() -> ValueValidator

    /// Sets custom error message when  `required()` validation fails
    @discardableResult func requiredErrorMessage(_ message: String) -> ValueValidator

    /**
     Value has to be not empty (count/lenght > 0).
     - Supported types: **String, Data, Dictionary, Array, Set**
     - Note: If *required()* rule is not set but value is *nil* then any rule is skipped
     - Returns: `ValidationError.Code.required` if validation fail
     */
    @discardableResult func notEmpty() -> ValueValidator

    /// Sets custom error message when `empty()` validation fails
    @discardableResult func emptyErrorMessage(_ message: String) -> ValueValidator

    /**
     Validates equaility of value to validate against passed one
     - Parameters:
        - to: Value to compare against. Must confrom to *Equatable*
     - Returns: `ValidationError.Code.empty` if validation fails
     */
    @discardableResult func equal<T: Equatable>(to: T) -> ValueValidator

    /// Sets custom error message when `equal(to:)` validation fails
    @discardableResult func notEqualErrorMessage(_ message: String) -> ValueValidator

    /**
     Sets block to execute before validation that tells whether rule to validate or skip.
     - Parameters:
        - condition: `ValidationCondition` block that tells skip validation or not
    */
    @discardableResult func when(condition: @escaping ValidationCondition) -> ValueValidator

    /**
     Sets list of scenarios that rules to be referenced to.
     Rules are validated only if current scenario is among provided.
     If empty all rules will be executed.
     - Parameters:
        - scenarios: `[Scenario]` for which rules are validated only.
    */
    @discardableResult func forScenarios(_ scenarios: [Scenario]) -> ValueValidator

    /**
     Performs validation logic by executing rules and collection errors
     - Parameters:
        - value: Value to validate
        - tillFirstError: If `true` then validation stops when first error found
        - scenario: Optional scenario to run validation for. Only rules referenced with provided screnario will be executed
     - Returns: List of errors was found. Empty if all rules validated successfully
    */
    func validate(value: Any?, tillFirstError: Bool, scenario: Scenario?) -> [ValidationError]
}
