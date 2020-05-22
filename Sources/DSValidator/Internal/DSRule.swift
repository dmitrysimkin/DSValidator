//
//  DSRule.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/25/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

final class DSValidation: Validation {
    let name: String
    let block: ValidationBlock

    init(name: String, block: @escaping ValidationBlock) {
        self.name = name
        self.block = block
    }
}
