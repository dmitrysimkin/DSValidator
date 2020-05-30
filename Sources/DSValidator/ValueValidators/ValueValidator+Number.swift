//
//  DSValueValidator+Number.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/2/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation


public protocol NumberValueValidator {
    @discardableResult func greaterThan(_ limit: DSNumber) -> ValueValidator
    @discardableResult func greaterThanOrEqual(_ limit: DSNumber) -> ValueValidator
    @discardableResult func smallerThan(_ limit: DSNumber) -> ValueValidator
    @discardableResult func smallerThanOrEqual(_ limit: DSNumber) -> ValueValidator
    @discardableResult func `true`() -> ValueValidator
    @discardableResult func `false`() -> ValueValidator

    @discardableResult func notGreaterThanErrorMessage(_ message: String) -> ValueValidator
    @discardableResult func notGreaterThanOrEqualErrorMessage(_ message: String) -> ValueValidator
    @discardableResult func notSmallerThanErrorMessage(_ message: String) -> ValueValidator
    @discardableResult func notSmallerThanOrEqualErrorMessage(_ message: String) -> ValueValidator
    @discardableResult func notTrueErrorMessage(_ message: String) -> ValueValidator
    @discardableResult func notFalseErrorMessage(_ message: String) -> ValueValidator

}
