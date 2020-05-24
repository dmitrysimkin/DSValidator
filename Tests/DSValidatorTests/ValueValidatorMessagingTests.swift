//
//  ValueValidatorMessagingTests.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 2/29/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import XCTest
@testable import DSValidator

class ValueValidatorMessagingTests: XCTestCase {

    let validator = DSValueValidator(property: DefaultValueValidatorName)

    func testDefaultMessageReturnedIfNoCustomMessagesAndNoMessagesDelegate() {
        let defaultMessagesProvider = MockErrorMessagesDelegate()
        defaultMessagesProvider.errorMessageHook = { (_,_) in
            return "Default Message"
        }
        let validator = DSValueValidator(property: DefaultValueValidatorName, defaultMessagesProvider: defaultMessagesProvider)
        XCTAssertNil(validator.delegate)
        validator.fail(.empty)
        var error = validator.validate(value: "Test")
        XCTAssertEqual(error?.localizedDescription, "Default Message")

        validator.setErrorMessage("Custom Single Message", for: .empty)
        error = validator.validate(value: 12)
        XCTAssertNotEqual(error?.localizedDescription, "Default Message")
        XCTAssertEqual(error?.localizedDescription, "Custom Single Message")
    }

    func testSignleMessageCustomization() {
        let validator = DSValueValidator(property: DefaultValueValidatorName)
        validator.fail(.empty)
        validator.setErrorMessage("Custom", for: .empty)
        let error = validator.validate(value: "Test")
        XCTAssertEqual(error?.localizedDescription, "Custom")
    }

    func testProperOrderAskingForMessageError() {
        let defaultMessagesProvider = MockErrorMessagesDelegate()
        defaultMessagesProvider.errorMessageHook = { (_,_) in
            return "Default Message"
        }
        let validator = DSValueValidator(property: DefaultValueValidatorName, defaultMessagesProvider: defaultMessagesProvider)
        XCTAssertNil(validator.delegate)
        validator.fail(.empty)

        // Test default messages has lowest priority to get message
        var error = validator.validate(value: "Test")
        XCTAssertEqual(error?.localizedDescription, "Default Message")

        // custom delegate messages has higher priority than default messages
        let customMessagesDelegate = MockErrorMessagesDelegate()
        customMessagesDelegate.errorMessageHook = { (_,_) in
            return "Custom Delegate Message"
        }
        validator.delegate = customMessagesDelegate
        error = validator.validate(value: 12)
        XCTAssertNotEqual(error?.localizedDescription, "Default Message")
        XCTAssertEqual(error?.localizedDescription, "Custom Delegate Message")

        // custom single messages has higher priority than custom delegate messages
        validator.setErrorMessage("Custom Single Message", for: .empty)
        error = validator.validate(value: 12)
        XCTAssertNotEqual(error?.localizedDescription, "Default Message")
        XCTAssertEqual(error?.localizedDescription, "Custom Single Message")
    }

    func testDelegateCalledWhenProvidedWhileValidateAll() {
        let delegate = MockErrorMessagesDelegate()
        let expectation = XCTestExpectation()
        let requiredMessage = "Required"
        let allowEmptyMessage = "Allow Empty"
        let wrongTypeMessage = "Wrong Type"
        expectation.expectedFulfillmentCount = 3
        delegate.errorMessageHook = { (code, _) in
            expectation.fulfill()
            switch code {
            case .required:
                return requiredMessage
            case .empty:
                return allowEmptyMessage
            case .wrongType:
                return wrongTypeMessage
            default:
                XCTFail()
                return ""
            }
        }

        let testCases: [(input: Any?, expectedMessage: String)] = [
            (nil, requiredMessage),
            ("", allowEmptyMessage),
            (1, wrongTypeMessage)
        ]

        for testCase in testCases {
            let validator = DSValueValidator(property: DefaultValueValidatorName)
            validator.delegate = delegate
            validator.required().notEmpty().earlierThan(Date())
            let error = validator.validateAll(value: testCase.input).first
            XCTAssertEqual(error?.localizedDescription, testCase.expectedMessage)
        }

        wait(for: [expectation], timeout: 0)
    }

    func testDelegateCalledWhenProvidedWhileValidateUntillFirst() {
        let delegate = MockErrorMessagesDelegate()
        let expectation = XCTestExpectation()
        let requiredMessage = "Test Required"
        delegate.errorMessageHook = { (_, _) in
            expectation.fulfill()
            return requiredMessage
        }

        validator.delegate = delegate
        validator.required()
        let error = validator.validate(value: nil)
        XCTAssertEqual(error?.localizedDescription, requiredMessage)
        wait(for: [expectation], timeout: 0)
    }

    func testProperValuesPassedToDelegate() {
        let validator = DSValueValidator(property: DefaultValueValidatorName)
        validator.addValidation(named: "Rule1", block: { _ in return .custom(0) })
        let delegate = MockErrorMessagesDelegate()
        var expectation = XCTestExpectation()
        delegate.errorMessageHook = { (code, name) in
            XCTAssertEqual(name, DefaultValueValidatorName)
            XCTAssertEqual(code, .custom(0))
            expectation.fulfill()
            return ""
        }

        validator.delegate = delegate

        let _ = validator.validate(value: 3.3)
        wait(for: [expectation], timeout: 0)

        validator.addValidation(named: "Rule2", block: { _ in return .custom(0) })
        expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        delegate.errorMessageHook = { (code, name) in
            XCTAssertEqual(name, DefaultValueValidatorName)
            XCTAssertEqual(code, .custom(0))
            expectation.fulfill()
            return ""
        }

        validator.delegate = delegate
        let _ = validator.validateAll(value: "Test")
        wait(for: [expectation], timeout: 0)
    }

    // custom errors

    func testCustomErrorReturned() {
        validator.pg13()
        let error = validator.validate(value: 12)
        XCTAssertEqual(error?.code, .custom(underPG13ErrorCode))
    }

    // capitalizing value names

    func testDefaultMessagesIsNotNil() {
        let provider = DSDefaultMessagesProvider()
        func defaultMessage(_ code: ValidationError.Code) -> String? {
            return provider.errorMessage(by: code, for: DefaultValueValidatorName)
        }
        XCTAssertNotNil(defaultMessage(.required))
        XCTAssertNotNil(defaultMessage(.empty))
        XCTAssertNotNil(defaultMessage(.wrongType))

        //Date
        XCTAssertNotNil(defaultMessage(.notEarlierThan))
        XCTAssertNotNil(defaultMessage(.notLaterThan))
        XCTAssertNotNil(defaultMessage(.notEarlierThanOrEqualTo))
        XCTAssertNotNil(defaultMessage(.notLaterThanOrEqualTo))
        XCTAssertNotNil(defaultMessage(.notBetweenDates))

        // Strings
        XCTAssertNotNil(defaultMessage(.lengthNotFrom))
        XCTAssertNotNil(defaultMessage(.lengthNotUpTo))
        XCTAssertNotNil(defaultMessage(.lengthNotExact))
        XCTAssertNotNil(defaultMessage(.lengthNotFromTo))
        XCTAssertNotNil(defaultMessage(.notMatch))
        XCTAssertNotNil(defaultMessage(.notDiffer))
        XCTAssertNotNil(defaultMessage(.notDecimal))
        XCTAssertNotNil(defaultMessage(.noEmoji))

        // Numbers
        XCTAssertNotNil(defaultMessage(.notGreater))
        XCTAssertNotNil(defaultMessage(.notGreaterOrEqual))
        XCTAssertNotNil(defaultMessage(.notSmaller))
        XCTAssertNotNil(defaultMessage(.notSmallerOrEqual))

        // syntax
        XCTAssertNotNil(defaultMessage(.notEmail))
        XCTAssertNotNil(defaultMessage(.notName))
        XCTAssertNotNil(defaultMessage(.notHTTP))
        XCTAssertNotNil(defaultMessage(.notFile))
        XCTAssertNotNil(defaultMessage(.notWebSocket))
        XCTAssertNotNil(defaultMessage(.notIPv4))
        XCTAssertNotNil(defaultMessage(.notIPv6))
        XCTAssertNotNil(defaultMessage(.notMatchToRegexp))
        XCTAssertNotNil(defaultMessage(.notDomain))
        XCTAssertNotNil(defaultMessage(.notGeoCoordinate))

        // Collections
        XCTAssertNotNil(defaultMessage(.notIncludes))
        XCTAssertNotNil(defaultMessage(.notExcludes))
        XCTAssertNotNil(defaultMessage(.notIncludedIn))
        XCTAssertNotNil(defaultMessage(.notExcludedFrom))
    }
}
