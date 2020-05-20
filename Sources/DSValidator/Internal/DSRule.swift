//
//  DSRule.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/25/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

final class DSRule: Rule {
    let name: String
    let validationBlock: ValidationBlock

    init(name: String, validationBlock: @escaping ValidationBlock) {
        self.name = name
        self.validationBlock = validationBlock
    }
}
