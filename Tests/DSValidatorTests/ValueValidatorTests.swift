//
//  ValueValidatorTests.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/23/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import XCTest
@testable import DSValidator

// TODO: generic equal, to be able compare enums for example
class ValueValidatorTests: XCTestCase {

    let validator = DSValueValidator(property: DefaultValueValidatorName, defaultMessagesProvider: MockErrorMessagesDelegate())

    func testInit() {
        XCTAssertEqual(validator.order, 500)
        XCTAssertEqual(validator.property, DefaultValueValidatorName)
    }

    func testOrder() {
        validator.order(100)
        XCTAssertEqual(validator.order, 100)
        validator.order(1000)
        XCTAssertEqual(validator.order, 1000)
        validator.order(32)
        XCTAssertEqual(validator.order, 32)
        validator.order(1)
        XCTAssertEqual(validator.order, 1)
    }

    func testChangeLocalizedName() {
        let localizedName = "localized validator"
        XCTAssertEqual(validator.localizedName, validator.property)
        validator.localizedName(localizedName)
        XCTAssertEqual(validator.localizedName, localizedName)
    }

    func testErrorMessageWithLocalizedNameShouldStartWithLocalizedDescription() {
        let validator = DSValueValidator(property: DefaultValueValidatorName)
        let localizedName = "localized validator"
        XCTAssertEqual(validator.localizedName, validator.property)
        validator.localizedName(localizedName)
            .emptyTestRule()
        let error = validator.validate(value: "any")
        XCTAssertTrue(error?.localizedDescription.starts(with: "Localized Validator") ?? false)
    }

    func testNameIsCapitalizedForDefaultErrorMessages() {
        var validator = DSValueValidator(property: "date")
        validator.fail(.empty)
        var error = validator.validate(value: Date(timeIntervalSince1970: 0))
        XCTAssertFalse(error?.localizedDescription.starts(with: "date") ?? false)
        XCTAssertTrue(error?.localizedDescription.starts(with: "Date") ?? false)

        validator = DSValueValidator(property: "total amount")
        validator.fail(.empty)
        error = validator.validate(value: Float(132.32))
        XCTAssertFalse(error?.localizedDescription.starts(with: "total amount") ?? false)
        XCTAssertTrue(error?.localizedDescription.starts(with: "Total Amount") ?? false)
    }

    func testErrorMessageWithoutLocalizedNameShouldStartWithName() {
        let property = "validator"
        let validator = DSValueValidator(property: property)
        validator.emptyTestRule()
        let error = validator.validate(value: "any")
        XCTAssertTrue(error?.localizedDescription.starts(with: "Validator") ?? false)
    }

    func testAddingOneRules() {
        XCTAssertEqual(validator.validations.count, 0)
        validator.emptyTestRule()
        XCTAssertEqual(validator.validations.count, 1)
        XCTAssertEqual(validator.validations.first?.name, DefaultValueValidatorName)
    }

    func testAddingTwoRules() {
        XCTAssertEqual(validator.validations.count, 0)
        validator.emptyTestRule()
        XCTAssertEqual(validator.validations.count, 1)
        XCTAssertEqual(validator.validations.first?.name, DefaultValueValidatorName)
        validator.emptyTestRule()
        XCTAssertEqual(validator.validations.count, 2)
    }

    func testRequiredFailedWhenNil() {
        validator.required()
        let error: ValidationError? = ValidationError(.required)
        let string: String? = nil
        XCTAssertEqual(validator.validate(value: string), error)
        let int: Int? = nil
        XCTAssertEqual(validator.validate(value: int), error)
        let double: Double? = nil
        XCTAssertEqual(validator.validate(value: double), error)
        let date: Date? = nil
        XCTAssertEqual(validator.validate(value: date), error)
        let data: Data? = nil
        XCTAssertEqual(validator.validate(value: data), error)
        let uuid: UUID? = nil
        XCTAssertEqual(validator.validate(value: uuid), error)
        struct Struct { }
        let customStruct: Struct? = nil
        XCTAssertEqual(validator.validate(value: customStruct), error)
        class CustomClass { }
        let customClass: CustomClass? = nil
        XCTAssertEqual(validator.validate(value: customClass), error)
        let array: [String]? = nil
        XCTAssertEqual(validator.validate(value: array), error)
        let set: Set<String>? = nil
        XCTAssertEqual(validator.validate(value: set), error)
        let dict: [Int: Double]? = nil
        XCTAssertEqual(validator.validate(value: dict), error)
    }

    func testRequiredSuccessWhenNotNil() {
        let _ = validator.required
        let string: String? = "Test"
        XCTAssertNil(validator.validate(value: string))
        let int: Int? = 0
        XCTAssertNil(validator.validate(value: int))
        let double: Double = 10.3
        XCTAssertNil(validator.validate(value: double))
        let date: Date? = Date()
        XCTAssertNil(validator.validate(value: date))
        let data: Data? = Data()
        XCTAssertNil(validator.validate(value: data))
        let uuid = UUID()
        XCTAssertNil(validator.validate(value: uuid))
        struct Struct { }
        let customStruct = Struct()
        XCTAssertNil(validator.validate(value: customStruct))
        class CustomClass { }
        let customClass: CustomClass? = CustomClass()
        XCTAssertNil(validator.validate(value: customClass))
        let array: [String]? = ["nil", "none"]
        XCTAssertNil(validator.validate(value: array))
        let set: Set<Int>? = Set(arrayLiteral: 1,2,3)
        XCTAssertNil(validator.validate(value: set))
        let dict: [Int: Double]? = [0: 0.5, 1: 1.5, 2: 3.5]
        XCTAssertNil(validator.validate(value: dict))
    }

    func testOnlyOneErrorReturnedIfRequiredAndOtherRulesApplied() {
        validator.required()
            .fail(.custom(0))
            .emptyTestRule()
        let value: String? = nil
        let errors = validator.validateAll(value: value)
        XCTAssertEqual(errors.count, 1)
        XCTAssertEqual(errors.first, ValidationError(.required))
    }

    func testAllRulesSkippedIfNilValuePassedAndNotRequired() {
        validator.notEmpty()
            .fail(.custom(0))
            .emptyTestRule()
            .fail(.custom(1))
        let value: String? = nil
        let errors = validator.validateAll(value: value)
        XCTAssertEqual(errors.count, 0)
    }

    func testNotAllowedEmptyByDefault() {
        validator.notEmpty()
        let error: ValidationError? = ValidationError(.empty)
        let string = ""
        XCTAssertEqual(validator.validate(value: string), error)
        let array = [Int]()
        XCTAssertEqual(validator.validate(value: array), error)
        let set = Set<Double>()
        XCTAssertEqual(validator.validate(value: set), error)
        let dict = [String: Date]()
        XCTAssertEqual(validator.validate(value: dict), error)
        let data = Data()
        XCTAssertEqual(validator.validate(value: data), error)
    }

    func testNotAllowedEmptyAndRequired() {
        let error: ValidationError? = ValidationError(.empty)
        validator.required().notEmpty()
        XCTAssertEqual(validator.validate(value: ""), error)
    }

    func testAllowedNonEmpty() {
        validator.notEmpty()
        let string = " "
        XCTAssertNil(validator.validate(value: string))
        let array = [1,2,3]
        XCTAssertNil(validator.validate(value: array))
        let set = Set<Double>(arrayLiteral: 1.3, 200, 33.33)
        XCTAssertNil(validator.validate(value: set))
        let dict: [String : Any] = ["one": Date(), "two": 33]
        XCTAssertNil(validator.validate(value: dict))
        let data = Data(base64Encoded: "Test")
        XCTAssertNil(validator.validate(value: data))
    }

    func testAllowedEmptyByDefault() {
        let string = ""
        XCTAssertNil(validator.validate(value: string))
        let array = [Int]()
        XCTAssertNil(validator.validate(value: array))
        let set = Set<Double>()
        XCTAssertNil(validator.validate(value: set))
        let dict = [String: Date]()
        XCTAssertNil(validator.validate(value: dict))
        let data = Data()
        XCTAssertNil(validator.validate(value: data))
    }

    func testOnlyOneErrorReturnedIfNotAllowEmptyAndOtherRulesApplied() {
        validator.notEmpty()
            .fail(.custom(0))
            .emptyTestRule()
        let value: String? = ""
        let errors = validator.validateAll(value: value)
        XCTAssertEqual(errors.count, 1)
        XCTAssertEqual(errors.first, ValidationError(.empty))
    }

    func testValidateReturnsFirstError() {
        let expectation1 = XCTestExpectation()
        let block1: ValidationBlock = { (_) -> ValidationError.Code in
            expectation1.fulfill()
            return .required
        }
        let expectation2 = XCTestExpectation()
        expectation2.isInverted = true
        let block2: ValidationBlock = { (_) -> ValidationError.Code in
            expectation2.fulfill()
            return .custom(0)
        }

        validator.addValidation(named: "Rule1", block: block1)
        validator.addValidation(named: "Rule2", block: block2)

        let error = validator.validate(value: "")
        XCTAssertEqual(error, ValidationError(.required))
        wait(for: [expectation1, expectation2], timeout: 0)
    }

    func testValidateAll() {
        let expectation1 = XCTestExpectation()
        let block1: ValidationBlock =  { (_) -> ValidationError.Code in
            expectation1.fulfill()
            return .required
        }
        let expectation2 = XCTestExpectation()
        let block2: ValidationBlock = { (_) -> ValidationError.Code in
            expectation2.fulfill()
            return .empty
        }
        validator.addValidation(named: "Rule1", block: block1)
        validator.addValidation(named: "Rule2", block: block2)

        let errors = validator.validateAll(value: 0)
        XCTAssertEqual(errors.count, 2)
        XCTAssertTrue(errors.contains(ValidationError(.required)))
        XCTAssertTrue(errors.contains(ValidationError(.empty)))
        wait(for: [expectation1, expectation2], timeout: 0)
    }

    func testNotEmptyPassingNil() {
        validator.notEmpty()
        XCTAssertNil(validator.validate(value: nil))
    }

    // MARK: - Condition

    func testRulesNotExecutedIfConditionIsFalseNoScenario() {
        let expectation1 = XCTestExpectation(isInverted: true)
        let block1: ValidationBlock =  { (_) -> ValidationError.Code in
            expectation1.fulfill()
            return .required
        }
        let expectation2 = XCTestExpectation(isInverted: true)
        let block2: ValidationBlock = { (_) -> ValidationError.Code in
            expectation2.fulfill()
            return .empty
        }
        let whenConditionCalledExpectation = XCTestExpectation()
        validator.addValidation(named: "Rule1", block: block1)
        validator.addValidation(named: "Rule2", block: block2)
        validator.when(condition: {
            whenConditionCalledExpectation.fulfill()
            return false
        })

        let errors = validator.validateAll(value: 0)
        XCTAssertEqual(errors.count, 0)
        wait(for: [expectation1, expectation2, whenConditionCalledExpectation], timeout: 0)
    }

    func testRulesNotExecutedIfConditionIsTrueNoScenario() {
        let expectation1 = XCTestExpectation()
        let block1: ValidationBlock =  { (_) -> ValidationError.Code in
            expectation1.fulfill()
            return .required
        }
        let expectation2 = XCTestExpectation()
        let block2: ValidationBlock = { (_) -> ValidationError.Code in
            expectation2.fulfill()
            return .empty
        }
        let whenConditionCalledExpectation = XCTestExpectation()
        validator.addValidation(named: "Rule1", block: block1)
        validator.addValidation(named: "Rule2", block: block2)
        validator.when(condition: {
            whenConditionCalledExpectation.fulfill()
            return true
        })

        let errors = validator.validateAll(value: 0)
        XCTAssertEqual(errors.count, 2)
        wait(for: [expectation1, expectation2, whenConditionCalledExpectation], timeout: 0)
    }

    // MARK: - Scenario

    func testRuleValidatedIfScenarioIsEmpty() {
        let expectation = XCTestExpectation()
        validator.addValidation(named: "Rule") { (_) -> ValidationError.Code? in
            expectation.fulfill()
            return .custom(3)
        }

        validator.forScenarios([])
        XCTAssertEqual(validator.validate(value: "value")?.code, .custom(3))
        wait(for: [expectation], timeout: 0)
    }


    func testRuleValidatedIfScenarioSetButRunWithoutScenario() {
        let expectation = XCTestExpectation()
        validator.addValidation(named: "Rule") { (_) -> ValidationError.Code? in
            expectation.fulfill()
            return .custom(3)
        }

        validator.forScenarios(["S1"])
        XCTAssertEqual(validator.validate(value: "value")?.code, .custom(3))
        wait(for: [expectation], timeout: 0)
    }

    func testRuleValidatedIfScenarioSetToOneFromScenarios() {
        let expectation = XCTestExpectation()
        validator.addValidation(named: "Rule") { (_) -> ValidationError.Code? in
            expectation.fulfill()
            return .custom(3)
        }

        validator.forScenarios(["S1", "S2"])
        XCTAssertEqual(validator.validate(value: "value", scenario: "S1")?.code, .custom(3))
        wait(for: [expectation], timeout: 0)
    }

    func testRuleNotValidatedIfScenarioSetToOneNotInScenarios() {
        let expectation = XCTestExpectation(isInverted: true)
        validator.addValidation(named: "Rule") { (_) -> ValidationError.Code? in
            expectation.fulfill()
            return .custom(3)
        }

        validator.forScenarios(["S2", "S1"])
        XCTAssertNil(validator.validate(value: "value", scenario: "S3"))
        wait(for: [expectation], timeout: 0)
    }

    // Scenario + Condition

    func testRuleNotValidatedIfScenarioSetToOneFromScenariosButConditionIsFalse() {
        let expectation = XCTestExpectation(isInverted: true)
        validator.addValidation(named: "Rule") { (_) -> ValidationError.Code? in
            expectation.fulfill()
            return .custom(3)
        }

        let whenConditionCalledExpectation = XCTestExpectation()
        validator.when(condition: {
            whenConditionCalledExpectation.fulfill()
            return false
        })

        validator.forScenarios(["S2", "S1"])
        XCTAssertNil(validator.validate(value: "value", scenario: "S1"))
        wait(for: [expectation, whenConditionCalledExpectation], timeout: 0)
    }

    // MARK: - Equal
    func testEqualWithEnum() {
        validator.equal(TestEnum.one)
        XCTAssertEqual(validator.validate(value: TestEnum.two)?.code, .notEqual)
        XCTAssertNil(validator.validate(value: TestEnum.one))
    }

    func testEqualWithCustomType() {
        let expected = TestStructWithComputedProperty(stored: "Stored", multiplier: 3)
        validator.equal(expected)
        let val1 = TestStructWithComputedProperty(stored: "Stored", multiplier: 2)
        XCTAssertEqual(validator.validate(value: val1)?.code, .notEqual)
        let val2 = TestStructWithComputedProperty(stored: "Stored", multiplier: 3)
        XCTAssertNil(validator.validate(value: val2))
    }

    func testEqualWithNumber() {
        var validator = makeDefaultValidator()
        validator.equal(Float(1/3))
        XCTAssertNil(validator.validate(value: 1/3))
        XCTAssertNil(validator.validate(value: Decimal(1/3)))
        XCTAssertNil(validator.validate(value: NSNumber(value: 1/3)))
        XCTAssertEqual(validator.validate(value: 1)?.code, .notEqual)

        validator = makeDefaultValidator()
        validator.equal(10)
        XCTAssertNil(validator.validate(value: UInt8(10)))
        XCTAssertNil(validator.validate(value: Float(10)))
        XCTAssertNil(validator.validate(value: Decimal(10.00)))
        XCTAssertNil(validator.validate(value: Double(10.0)))
        XCTAssertNil(validator.validate(value: NSNumber(value: 10)))
        XCTAssertEqual(validator.validate(value: 1)?.code, .notEqual)

        validator = makeDefaultValidator()
        validator.equal(Double(13))
        XCTAssertNil(validator.validate(value: UInt8(13)))
        XCTAssertNil(validator.validate(value: Int(13)))
        XCTAssertNil(validator.validate(value: Float(13)))
        XCTAssertNil(validator.validate(value: Decimal(13.00)))
        XCTAssertNil(validator.validate(value: NSNumber(value: 13)))
        XCTAssertEqual(validator.validate(value: 1)?.code, .notEqual)
    }


    // MARK: - Messages

    func testMessages() {
        var validator: ValueValidator
        validator = makeDefaultValidator().fail(.notEqual).notEqualMessage("NotEqual")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notEqual, message: "NotEqaual"))

        validator = makeDefaultValidator().fail(.required).requiredMessage("Required")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.required, message: "Required"))

        validator = makeDefaultValidator().fail(.empty).emptyMessage("Empty")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.empty, message: "Emptyy"))
    }

}


