//
//  ValueValidator+SyntaxSugar.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/25/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

extension ValueValidator {
    var `is`: ValueValidator { self }
    var are: ValueValidator { self }
    var on: ValueValidator { self }
    var have: ValueValidator { self }
    var has: ValueValidator { self }
    var must: ValueValidator { self }
    var to: ValueValidator { self }
    var notTo: ValueValidator { self }
    var be: ValueValidator { self }
    var with: ValueValidator { self }
    var contains: ValueValidator { self }
    var only: ValueValidator { self }
}
