//
//  ValidationErrorTests.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 3/20/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import XCTest

class ValidationErrorTests: XCTestCase {

    func testInitWithCode() {
        let error = ValidationError(.notSmaller, message: nil)
        XCTAssertEqual(error.code, .notSmaller)
    }

    func testDefaultErrorMessage() {
        let error = ValidationError(.required, message: nil)
        XCTAssertEqual(error.errorDescription, "Validation Error")
    }

    func testNotEqualByMessage() {
        let lhs = ValidationError(.wrongType, message: "LHS")
        let rhs = ValidationError(.wrongType, message: "RHS")
        XCTAssertNotEqual(lhs, rhs)
    }

    func testEqualityWithCustomCode() {
        XCTAssertNotEqual(ValidationError(.custom(0)), ValidationError(.custom(1)))
        XCTAssertEqual(ValidationError(.custom(100)), ValidationError(.custom(100)))
    }
}
