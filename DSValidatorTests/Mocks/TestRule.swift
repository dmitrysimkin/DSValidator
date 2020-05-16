//
//  TestRule.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 2/25/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

final class TestRule: Rule {
    var name: String

    var validationBlock: ValidationBlock

    init(name: String, validationBlock: @escaping ValidationBlock) {
        self.name = name
        self.validationBlock = validationBlock
    }
}
