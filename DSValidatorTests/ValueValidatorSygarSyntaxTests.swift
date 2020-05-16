//
//  ValueValidatorSygarSyntaxTests.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 2/25/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import XCTest
@testable import DSValidator

class ValueValidatorSygarSyntaxTests: XCTestCase {

    let validator: ValueValidator = DSValueValidator(name: DefaultValueValidatorName)

    func testSugar() {
        XCTAssertTrue(validator === validator.is)
        XCTAssertTrue(validator === validator.are)
        XCTAssertTrue(validator === validator.on)
        XCTAssertTrue(validator === validator.have)
        XCTAssertTrue(validator === validator.has)
        XCTAssertTrue(validator === validator.must)
        XCTAssertTrue(validator === validator.to)
        XCTAssertTrue(validator === validator.notTo)
        XCTAssertTrue(validator === validator.be)
        XCTAssertTrue(validator === validator.with)
        XCTAssertTrue(validator === validator.contains)
        XCTAssertTrue(validator === validator.only)
    }
}

