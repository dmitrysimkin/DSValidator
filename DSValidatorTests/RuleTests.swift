//
//  RuleTests.swift
//  RuleTests
//
//  Created by Dzmitry Simkin on 2/22/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import XCTest
@testable import DSValidator

class RuleTests: XCTestCase {

    func testInit() {
        let block: ValidationBlock = { _ in return .empty }
        let name = "Test name"
        let rule = TestRule(name: name, validationBlock: block)
        XCTAssertEqual(rule.name, name)
        XCTAssertTrue(rule.validationBlock(nil) == block(""))
    }
}
