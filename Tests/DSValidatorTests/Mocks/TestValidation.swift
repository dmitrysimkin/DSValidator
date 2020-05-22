//
//  TestValidation.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 2/25/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

final class TestValidation: Validation {
    var name: String
    var block: ValidationBlock

    init(name: String, block: @escaping ValidationBlock) {
        self.name = name
        self.block = block
    }
}
