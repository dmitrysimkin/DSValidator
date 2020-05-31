//
//  ValueValidatorNumberTests.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 5/2/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import XCTest
@testable import DSValidator

class ValueValidatorNumberTests: XCTestCase {

    let validator = DSValueValidator(property: DefaultValueValidatorName)

    func testSettingLimitOfDifferentType() {
        var validator = makeDefaultValidator()
        validator.greaterThan(Int8(3))
        XCTAssertNil(validator.validate(value: 5))

        validator = makeDefaultValidator()
        validator.greaterThan(Int16(3))
        XCTAssertNil(validator.validate(value: 5))

        validator = makeDefaultValidator()
        validator.greaterThan(Int32(3))
        XCTAssertNil(validator.validate(value: 5))

        validator = makeDefaultValidator()
        validator.greaterThan(Int64(3))
        XCTAssertNil(validator.validate(value: 5))

        validator = makeDefaultValidator()
        validator.greaterThan(Int(3))
        XCTAssertNil(validator.validate(value: 5))

        validator = makeDefaultValidator()
        validator.greaterThan(UInt8(3))
        XCTAssertNil(validator.validate(value: 5))

        validator = makeDefaultValidator()
        validator.greaterThan(UInt16(3))
        XCTAssertNil(validator.validate(value: 5))

        validator = makeDefaultValidator()
        validator.greaterThan(UInt32(3))
        XCTAssertNil(validator.validate(value: 5))

        validator = makeDefaultValidator()
        validator.greaterThan(UInt64(3))
        XCTAssertNil(validator.validate(value: 5))

        validator = makeDefaultValidator()
        validator.greaterThan(UInt(3))
        XCTAssertNil(validator.validate(value: 5))

        validator = makeDefaultValidator()
        validator.greaterThan(Float(3))
        XCTAssertNil(validator.validate(value: 5))

        validator = makeDefaultValidator()
        validator.greaterThan(Decimal(3))
        XCTAssertNil(validator.validate(value: 5))

        validator = makeDefaultValidator()
        validator.greaterThan(NSNumber(3))
        XCTAssertNil(validator.validate(value: 5))

        validator = makeDefaultValidator()
        validator.greaterThan(NSDecimalNumber(3))
        XCTAssertNil(validator.validate(value: 5))
    }

    func testDifferentTypesOfLimitAndValue() {
        var validator = makeDefaultValidator()
        validator.greaterThan(3)
        XCTAssertNil(validator.validate(value: 5))
        XCTAssertNil(validator.validate(value: Float(5)))
        XCTAssertNil(validator.validate(value: Decimal(10)))
        XCTAssertNil(validator.validate(value: NSNumber(7)))
        XCTAssertNil(validator.validate(value: UInt(4)))

        validator = makeDefaultValidator()
        validator.greaterThan(UInt(3))
        XCTAssertNil(validator.validate(value: 5))
        XCTAssertNil(validator.validate(value: Float(5)))
        XCTAssertNil(validator.validate(value: Decimal(10)))
        XCTAssertNil(validator.validate(value: NSNumber(7)))
        XCTAssertNil(validator.validate(value: UInt(4)))

        validator = makeDefaultValidator()
        validator.greaterThan(Float(3))
        XCTAssertNil(validator.validate(value: 5))
        XCTAssertNil(validator.validate(value: Float(5)))
        XCTAssertNil(validator.validate(value: Decimal(10)))
        XCTAssertNil(validator.validate(value: NSNumber(7)))
        XCTAssertNil(validator.validate(value: UInt(4)))

        validator = makeDefaultValidator()
        validator.greaterThan(Decimal(3))
        XCTAssertNil(validator.validate(value: 5))
        XCTAssertNil(validator.validate(value: Float(5)))
        XCTAssertNil(validator.validate(value: Decimal(10)))
        XCTAssertNil(validator.validate(value: NSNumber(7)))
        XCTAssertNil(validator.validate(value: UInt(4)))

        validator = makeDefaultValidator()
        validator.greaterThan(NSNumber(3))
        XCTAssertNil(validator.validate(value: 5))
        XCTAssertNil(validator.validate(value: Float(5)))
        XCTAssertNil(validator.validate(value: Decimal(10)))
        XCTAssertNil(validator.validate(value: NSNumber(7)))
        XCTAssertNil(validator.validate(value: UInt(4)))
    }

    func testGreaterThan() {
        validator.greaterThan(Double(0))
        XCTAssertNil(validator.validate(value: 7))
        XCTAssertNil(validator.validate(value: Float(9.999999)))
        XCTAssertNil(validator.validate(value: 0.00000000000000000000000001))
        XCTAssertNil(validator.validate(value: Float(0.00000000000000000000000001)))
        XCTAssertEqual(validator.validate(value: 0)?.code, .notGreater)
        XCTAssertEqual(validator.validate(value: -11)?.code, .notGreater)
        XCTAssertEqual(validator.validate(value: Decimal(0))?.code, .notGreater)
    }

    func testGreaterThanOrEqual() {
        validator.greaterThanOrEqual(NSNumber(0))
        XCTAssertNil(validator.validate(value: 7))
        XCTAssertNil(validator.validate(value: Float(9.999999)))
        XCTAssertNil(validator.validate(value: 0.00000000000000000000000001))
        XCTAssertNil(validator.validate(value: Float(0.00000000000000000000000001)))
        XCTAssertNil(validator.validate(value: 0)?.code)
        XCTAssertNil(validator.validate(value: Decimal(0)))
        XCTAssertEqual(validator.validate(value: -0.000000000000000000001)?.code, .notGreaterOrEqual)
    }

    func testSmallerThan() {
        validator.smallerThan(Int(10))
        XCTAssertNil(validator.validate(value: 7))
        XCTAssertNil(validator.validate(value: -0.545))
        XCTAssertNil(validator.validate(value: -INT_MAX))
        XCTAssertNil(validator.validate(value: Float(9.999999)))
        XCTAssertEqual(validator.validate(value: 11)?.code, .notSmaller)
        XCTAssertEqual(validator.validate(value: Decimal(10.00001))?.code, .notSmaller)
    }

    func testSmallerThanOrEqual() {
        validator.smallerThanOrEqual(Float(33))
        XCTAssertNil(validator.validate(value: 7))
        XCTAssertNil(validator.validate(value: Float(32.999999)))
        XCTAssertNil(validator.validate(value: Float(33)))
        XCTAssertNil(validator.validate(value: Decimal(33)))
        XCTAssertNil(validator.validate(value: 33))
        XCTAssertEqual(validator.validate(value: 33.000001)?.code, .notSmallerOrEqual)
        XCTAssertEqual(validator.validate(value: Decimal(35))?.code, .notSmallerOrEqual)
        XCTAssertEqual(validator.validate(value: NSNumber(10000))?.code, .notSmallerOrEqual)
    }

    func testTrue() {
        validator.true()
        XCTAssertNil(validator.validate(value: true))
        XCTAssertEqual(validator.validate(value: false)?.code, .notTrue)
        XCTAssertEqual(validator.validate(value: 1)?.code, .wrongType)
    }

    func testFalse() {
        validator.false()
        XCTAssertNil(validator.validate(value: false))
        XCTAssertEqual(validator.validate(value: true)?.code, .notFalse)
        XCTAssertEqual(validator.validate(value: "gasdf")?.code, .wrongType)
    }

    func testNotNumberRetursWrongType() {
        validator.equal(to: 13)
        XCTAssertEqual(validator.validate(value: Data())?.code, .wrongType)
        XCTAssertEqual(validator.validate(value: Date())?.code, .wrongType)
        XCTAssertEqual(validator.validate(value: "")?.code, .wrongType)
        XCTAssertEqual(validator.validate(value: TestClass(age: 3, date: Date()))?.code, .wrongType)
    }

    // MARK: - Messaging

    func testMessages() {
        var validator: ValueValidator
        validator = makeDefaultValidator().fail(.notGreater).notGreaterThanErrorMessage("NotGreater")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notGreater, message: "NotGreater"))

        validator = makeDefaultValidator().fail(.notGreaterOrEqual).notGreaterThanOrEqualErrorMessage("NotGreaterOrEqual")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notGreaterOrEqual, message: "NotGreaterOrEqual"))

        validator = makeDefaultValidator().fail(.notSmaller).notSmallerThanErrorMessage("NotSmaller")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notSmaller, message: "NotSmaller"))

        validator = makeDefaultValidator().fail(.notSmallerOrEqual).notSmallerThanOrEqualErrorMessage("NotSmallerOrEqual")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notSmallerOrEqual, message: "NotSmallerOrEqual"))

        validator = makeDefaultValidator().fail(.notEqual).notEqualErrorMessage("NotEqual")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notEqual, message: "NotEqual"))

        validator = makeDefaultValidator().fail(.notTrue).notTrueErrorMessage("NotTrue")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notTrue, message: "NotTrue"))

        validator = makeDefaultValidator().fail(.notFalse).notFalseErrorMessage("NotFalse")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notFalse, message: "NotFalse"))
    }
}
