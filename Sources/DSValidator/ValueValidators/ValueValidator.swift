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

public protocol ValueValidator:  AnyObject,
        CustomValidation,
        DateValueValidator,
        StringValueValidator,
        SyntaxValueValidator,
        NumberValueValidator,
        CollectionValueValidator {
    var property: Property { get }
    var delegate: ErrorMessagesDelegate? { get set }
    var validations: [Validation] { get }
    var order: Int { get }
    var localizedName: String { get }

    @discardableResult func required() -> ValueValidator
    @discardableResult func notEmpty() -> ValueValidator // ADD doc notes that if only notEmpty rule and passing nil will return no errors
    @discardableResult func equal<T: Equatable>(to: T) -> ValueValidator

    @discardableResult func localizedName(_ name: String) -> ValueValidator
    @discardableResult func order(_ order: Int) -> ValueValidator
    @discardableResult func when(condition: @escaping ValidationCondition) -> ValueValidator
    @discardableResult func forScenarios(_ scenarios: [Scenario]) -> ValueValidator

    @discardableResult func requiredErrorMessage(_ message: String) -> ValueValidator
    @discardableResult func emptyErrorMessage(_ message: String) -> ValueValidator
    @discardableResult func notEqualErrorMessage(_ message: String) -> ValueValidator

    func validate(value: Any?, scenario: Scenario?) -> ValidationError?
    func validateAll(value: Any?, scenario: Scenario?) -> [ValidationError]
}
