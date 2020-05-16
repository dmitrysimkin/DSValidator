//
//  ValueValidatorCollectionTests.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 5/3/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import XCTest
@testable import DSValidator

class ValueValidatorCollectionTests: XCTestCase {

    let validator = DSValueValidator(name: DefaultValueValidatorName)

    func testincludesArray() {
        validator.includes(3)
        XCTAssertNil(validator.validate(value: [1, 2, 3]))
        XCTAssertEqual(validator.validate(value: [1, 2, 4])?.code, .notIncludes)
        XCTAssertEqual(validator.validate(value: [Int]())?.code, .notIncludes)
        XCTAssertEqual(validator.validate(value: Set(arrayLiteral: 1, 2, 4))?.code, .notIncludes)
    }

    func testincludesInSet() {
        validator.includes("two")
        XCTAssertNil(validator.validate(value: Set(arrayLiteral: "one", "two", "three")))
        XCTAssertEqual(validator.validate(value: Set(arrayLiteral: 1, 2, 4))?.code, .notIncludes)
        XCTAssertEqual(validator.validate(value: [1, 2, 4])?.code, .notIncludes)
    }

    func testincludesReturnsWrongTypeIfNotCollectionPassed() {
        validator.includes("two")
        XCTAssertEqual(validator.validate(value: "two")?.code, .wrongType)
        XCTAssertEqual(validator.validate(value: ["two", 1])?.code, .wrongType)
    }

    func testExcludesArray() {
        validator.excludes(5.0)
        XCTAssertNil(validator.validate(value: [1.9, 2.32, 3.4134]))
        XCTAssertNil(validator.validate(value: [Double]()))
        XCTAssertEqual(validator.validate(value: [5.0])?.code, .notExcludes)
        XCTAssertEqual(validator.validate(value: [-0.3, 23, 5.0])?.code, .notExcludes)
    }

    func testExcludesSet() {
        validator.excludes(5.0)
        XCTAssertNil(validator.validate(value: Set(arrayLiteral: 1.9, 2.32, 3.4134)))
        XCTAssertNil(validator.validate(value: Set<Double>()))
        XCTAssertEqual(validator.validate(value: Set(arrayLiteral: 5.0))?.code, .notExcludes)
        XCTAssertEqual(validator.validate(value: Set(arrayLiteral: -0.3, 23, 5.0))?.code, .notExcludes)
        XCTAssertEqual(validator.validate(value: Set(arrayLiteral: 1, 2, 5.0000))?.code, .notExcludes)
    }

    func testExcludesReturnsWrongTypeIfNotCollectionPassed() {
        validator.excludes("two")
        XCTAssertEqual(validator.validate(value: 2)?.code, .wrongType)
        XCTAssertEqual(validator.validate(value: ["two", 1])?.code, .wrongType)
    }

    func testIncludedInArray() {
        validator.includedIn([1,2,3])
        XCTAssertNil(validator.validate(value: 2))
        XCTAssertEqual(validator.validate(value: "two")?.code, .notIncludedIn)
    }

    func testIncludedInSet() {
        validator.includedIn(Set(arrayLiteral: 1,2,3))
        XCTAssertNil(validator.validate(value: 2))
        XCTAssertEqual(validator.validate(value: "two")?.code, .notIncludedIn)
    }

    func testExcludedFromArray() {
        validator.excludedFrom([1,2,3])
        XCTAssertNil(validator.validate(value: 5))
        XCTAssertNil(validator.validate(value: "five"))
        XCTAssertEqual(validator.validate(value: 2)?.code, .notExcludedFrom)
    }

    func testExcludedFromSet() {
        validator.excludedFrom(Set(arrayLiteral: 1,2,3))
        XCTAssertNil(validator.validate(value: 5))
        XCTAssertNil(validator.validate(value: "five"))
        XCTAssertEqual(validator.validate(value: 2)?.code, .notExcludedFrom)
    }

    // MARK: - Messaging

    func testMessaging() {
        var validator: ValueValidator
        validator = makeDefaultValidator().fail(.notIncludes).notIncludesMessage("Not includes")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notIncludes, message: "Not includes"))

        validator = makeDefaultValidator().fail(.notExcludes).notExcludesMessage("Not excludes") as! DSValueValidator
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notExcludes, message: "Not excludes"))

        validator = makeDefaultValidator().fail(.notIncludedIn).notIncludedInMessage("Not included") as! DSValueValidator
        XCTAssertEqual(validator.validate(value: [1,3], scenario: nil), ValidationError(.notIncludedIn, message: "Not included"))

        validator = makeDefaultValidator().fail(.notExcludedFrom).notExcludedFromMessage("Not excluded") as! DSValueValidator
        XCTAssertEqual(validator.validate(value: [1,3], scenario: nil), ValidationError(.notExcludedFrom, message: "Not excluded"))
    }

}
