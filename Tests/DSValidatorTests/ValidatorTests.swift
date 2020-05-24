//
//  ValidatorTests.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 3/20/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import XCTest
@testable import DSValidator

let emptyRules: Rules = { () -> [ValueValidator] in return [ValueValidator]() }

// TODO: capital and camel style model properties
class ObjectValidatorTests: XCTestCase {

    func testOptionalNilValueValidatedWithoutErrors() {
        let model = UserCredentialsInput(username: "Username", password: "12345678", confirmPassword: nil)
        let expectation = XCTestExpectation()
        let errors = DSValidator.validate(object: model) { () -> [ValueValidator] in
            [MockValueValidator(name: "confirmPassword").setValidateAllHook({ (value) -> [ValidationError]? in
                expectation.fulfill()
                XCTAssertNil(value)
                return nil
            })]
        }
        XCTAssertEqual(errors.count, 0)
        wait(for: [expectation], timeout: 0)
    }

    func testOptionalNilValueNotValid() {
        let model = UserCredentialsInput(username: "Username", password: "12345678", confirmPassword: nil)
        let expectation = XCTestExpectation()
        let errors = DSValidator.validate(object: model) { () -> [ValueValidator] in
            [MockValueValidator(name: "confirmPassword").setValidateAllHook({ (value) -> [ValidationError]? in
                expectation.fulfill()
                XCTAssertNil(value)
                return nil
            })]
        }
        XCTAssertEqual(errors.count, 0)
        wait(for: [expectation], timeout: 0)
    }

    func testNotNilOptionalValueNotValid() {
        let model = UserCredentialsInput(username: "Username", password: "12345678", confirmPassword: "123")
        let expectation = XCTestExpectation()
        let errors = DSValidator.validate(object: model, tillFirstError: true, rules: { () -> [ValueValidator] in
            return [MockValueValidator(name: "confirmPassword").setValidateHook({ (value) -> ValidationError? in
                expectation.fulfill()
                XCTAssertEqual(value as? String, "123")
                return ValidationError(.custom(1000))
            })]
        })
        XCTAssertEqual(errors.count, 1)
        XCTAssertEqual(errors.first?.code, .custom(1000))
        wait(for: [expectation], timeout: 0)
    }


    func testNotNilOptionalValueValidatedWithoutErrors() {
        let model = UserCredentialsInput(username: "Username", password: "12345678", confirmPassword: "password")
        let expectation = XCTestExpectation()
        let error = DSValidator.validate(object: model, tillFirstError: true, rules: { () -> [ValueValidator] in
            return [MockValueValidator(name: "confirmPassword").setValidateHook({ (value) -> ValidationError? in
                expectation.fulfill()
                XCTAssertEqual(value as? String, "password")
                return nil
            })]
        })
        XCTAssertEqual(error.count, 0)
        wait(for: [expectation], timeout: 0)
    }

    func testNotSupportedType() {
        let values: [Any] = [
            (1, "DASD"),
            TestEnum.two,
            TestEnumWithRawValue.thousand,
            TestEnumWithAssosiatedValue.lable("Test String"),
            [1,2,3,4],
            Set<String>(arrayLiteral: "", ",", "."),
            [1: "one", 2: "two", 3: "three"],
            Optional<Data>.some(Data()) as Any,
            Optional<Double>.none as Any
        ]
        for value in values {
            let errors = DSValidator.validate(object: value, rules: emptyRules)
            XCTAssertEqual(errors.count, 1, "Wrong errors count validating value: \(value) of type: \(type(of: value))")
            XCTAssertEqual(errors.first?.code, .objectOfNotSupportedType, "Wrong error code validating value: \(value) of type: \(type(of: value))")
        }
    }

    func testValueNotFoundForStruct() {
        let model = UserCredentialsInput(username: "Username", password: "12345678", confirmPassword: nil)
        let errors = DSValidator.validate(object: model) { () -> [ValueValidator] in
            return [DS.rule(for: "notExistingName").required().notEmpty().length(from: 3, to: 20)]
        }
        XCTAssertEqual(errors.count, 1)
        XCTAssertEqual(errors.first?.code, .valueNotFound)
    }

    func testValueNotFoundForClass() {
        let model = TestClass(age: 23, date: "27.12.2003")
        let errors = DSValidator.validate(object: model) { () -> [ValueValidator] in
            return [DSValueValidator(name: "username").required().notEmpty().length(from: 3, to: 20)]
        }
        XCTAssertEqual(errors.count, 1)
        XCTAssertEqual(errors.first?.code, .valueNotFound)
    }

    func testValueNotFoundTillFirstErrorReturnOnlyOneError() {
        let model = TestClass(age: 23, date: "27.12.2003")
        let errors = DSValidator.validate(object: model, tillFirstError: true) { () -> [ValueValidator] in
            return [DSValueValidator(name: "AGE").required().notEmpty().length(from: 3, to: 20),
                    DSValueValidator(name: "ages").required(),]
        }
        XCTAssertEqual(errors.count, 1)
        XCTAssertEqual(errors.first?.code, .valueNotFound)
    }

    func testValueNotFoundAllErrorsReturnsMoreThenOneError() {
        let model = UserCredentialsInput(username: "Username", password: "12345678", confirmPassword: nil)
        let errors = DSValidator.validate(object: model) { () -> [ValueValidator] in
            return [DS.rule(for: "Username").required().notEmpty().length(from: 3, to: 20),
                    DS.rule(for: "pass").required(),
                    DS.rule(for: "age").notEmpty()]
        }
        XCTAssertEqual(errors.count, 3)
        XCTAssertEqual(errors.map({ $0.code }), [.valueNotFound, .valueNotFound, .valueNotFound])
    }

    func testValidationBlocksNotCalledWhenValueNotFoundUntillFirstError() {
        let model = TestClass(age: 23, date: "27.12.2003")
        let expectation = XCTestExpectation(isInverted: true)
        let errors = DSValidator.validate(object: model, tillFirstError: true) { () -> [ValueValidator] in
            return [DS.rule(for: "AGE").addValidation(named: "Test Rule", block: { (_) -> ValidationError.Code? in
                expectation.fulfill()
                return .custom(0)
            })]
        }
        XCTAssertEqual(errors.count, 1)
        XCTAssertEqual(errors.first?.code, .valueNotFound)
        wait(for: [expectation], timeout: 0)
    }

    func testValidationBlocksNotCalledWhenValueNotFound() {
        let model = TestClass(age: 23, date: "27.12.2003")
        let expectation = XCTestExpectation(isInverted: true)
        let errors = DSValidator.validate(object: model) { () -> [ValueValidator] in
            return [
                DS.rule(for: "AGE").addValidation(named: "Test Rule", block: { (_) -> ValidationError.Code? in
                    expectation.fulfill()
                    return .custom(0)
                }), DS.rule(for: "interval").addValidation(named: "Test Rule", block: { (_) -> ValidationError.Code? in
                    expectation.fulfill()
                    return .custom(1)
                }), ]
        }
        XCTAssertEqual(errors.count, 2)
        XCTAssertEqual(errors.map({ $0.code }), [.valueNotFound, .valueNotFound])
        wait(for: [expectation], timeout: 0)
    }

    func testNonOptionalProtocolTypeValueValidatedSuccessfully() {
        let model = TestStructConformingProtocol(amount: 333.33, bonus: 0.1)
        let protocolModel: TestProtocol
        protocolModel = model
        let expectation = XCTestExpectation()
        let errors = DSValidator.validate(object: protocolModel, tillFirstError: true) { () -> [ValueValidator] in
            [MockValueValidator(name: "amount").setValidateHook({ (value) -> ValidationError? in
                expectation.fulfill()
                XCTAssertEqual(value as? Double, 333.33)
                return nil
            })]
        }
        XCTAssertEqual(errors.count, 0)
        wait(for: [expectation], timeout: 0)
    }

    func testOptionalProtocolTypeValueValidatedSuccessfully() {
        let model = TestClassConformingProtocol(amount: 333.33, bonus: 0.1)
        let protocolModel: TestProtocol
        protocolModel = model
        let expectation = XCTestExpectation()
        let errors = DSValidator.validate(object: protocolModel, tillFirstError: true) { () -> [ValueValidator] in
            [MockValueValidator(name: "bonus").setValidateHook({ (value) -> ValidationError? in
                expectation.fulfill()
                XCTAssertEqual(value as? Double, 0.1)
                return nil
            })]
        }
        XCTAssertEqual(errors.count, 0)
        wait(for: [expectation], timeout: 0)
    }

    func testGettingValueFromSubClass() {
        let model = TestSubClassB(age: 18, date: "03.03.2020", amount: 333.99, bonus: 10.50)
        let expectation = XCTestExpectation(callsCount: 3)
        let errors = DSValidator.validate(object: model, tillFirstError: true) { () -> [ValueValidator] in
            [MockValueValidator(name: "age").setValidateHook({ (value) -> ValidationError? in
                expectation.fulfill()
                XCTAssertEqual(value as? Int, 18)
                return nil
            }),
             MockValueValidator(name: "amount").setValidateHook({ (value) -> ValidationError? in
                expectation.fulfill()
                XCTAssertEqual(value as? Double, 333.99)
                return nil
             }),
             MockValueValidator(name: "optionalDate").setValidateHook({ (value) -> ValidationError? in
                expectation.fulfill()
                XCTAssertNil(value)
                return nil
             })]
        }
        XCTAssertEqual(errors.count, 0)
        wait(for: [expectation], timeout: 0)
    }

    func testCustomErrorDelagateIsSet() {
        let model = TestSubClassB(age: 18, date: "03.03.2020", amount: 333.99, bonus: 10.50)
        let delegate = MockErrorMessagesDelegate()

        let validateExpectation = XCTestExpectation()
        let valueValidator = MockValueValidator(name: "age")
        XCTAssertNil(valueValidator.delegate)
        let _ = valueValidator.setValidateHook({ (value) -> ValidationError? in
            validateExpectation.fulfill()
            XCTAssertEqual(value as? Int, 18)
            XCTAssertNotNil(valueValidator.delegate)
            return ValidationError(.notGreater)
        })
        _ = DSValidator.validate(object: model, tillFirstError: true, delegate: delegate) { [valueValidator] }
        wait(for: [validateExpectation], timeout: 0)
    }

    func testCustomErrorDelagateCalled() {
        let model = TestSubClassB(age: 18, date: "03.03.2020", amount: 333.99, bonus: 10.50)
        let delegate = MockErrorMessagesDelegate()
        let delegateExpectation = XCTestExpectation()
        delegate.errorMessageByCodeHook = { (code, name) in
            XCTAssertEqual(code, .notGreater)
            delegateExpectation.fulfill()
            return "Message"
        }

        let rule = DS.rule(for: "age", messagesProvider: delegate).required().greaterThan(21)
        let errors = DSValidator.validate(object: model, tillFirstError: true, delegate: delegate) { [rule] }
        guard let error = errors.first else {
            XCTFail("Should be an error")
            return
        }
        XCTAssertEqual(error, ValidationError(.notGreater, message: "Message"))
        wait(for: [delegateExpectation], timeout: 0)
    }
}

class OneValueValidatorTests: XCTestCase {

    func testStringValue() {
        let rule = DS.rule().required().length(exact: 4)
        let errors = DSValidator.validate(value: "Test", rule: rule)
        XCTAssertEqual(errors.count, 0)
    }

    func testDate() {
        let date: Date = "21.07.2012 11:59:59"
        let rule = DS.rule().required().earlierThan(Date())
        let errors = DSValidator.validate(value: date, rule: rule)
        XCTAssertEqual(errors.count, 0)
    }

    func testNumber() {
        let rule = DS.rule().required().greaterThan(18)
        let errors = DSValidator.validate(value: 21, rule: rule)
        XCTAssertEqual(errors.count, 0)
    }

    func testNilNumber() {
        let rule = DS.rule().required().greaterThan(18)
        let errors = DSValidator.validate(value: nil, rule: rule)
        XCTAssertEqual(errors.count, 1)
        XCTAssertEqual(errors.first?.code, .required)
    }

    func testCustomStruct() {
        var rule = DS.rule().required()
        let value = UserCredentialsInput(username: "bla", password: "test", confirmPassword: nil)
        var errors = DSValidator.validate(value: value, rule: rule)
        XCTAssertEqual(errors.count, 0)

        rule = DS.rule().required().smallerThan(20)
        errors = DSValidator.validate(value: value, rule: rule)
        XCTAssertEqual(errors.count, 1)
        XCTAssertEqual(errors.first?.code, .wrongType)
    }

    func testMultipleErrorsTillFirstErrorReturnOneError() {
        let rule = DS.rule().required().greaterThan(22).equal(50)
        let errors = DSValidator.validate(value: 21, tillFirstError: true, rule: rule)
        XCTAssertEqual(errors.count, 1)
        let code = errors.first!.code
        XCTAssertEqual(code, .notGreater)
    }
}

