//
//  DSAnyNumber.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/17/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

struct DSAnyNumber: Comparable {
    static func < (lhs: DSAnyNumber, rhs: DSAnyNumber) -> Bool {
        return lhs.number.toDecimal() < rhs.number.toDecimal()
    }

    static func == (lhs: DSAnyNumber, rhs: DSAnyNumber) -> Bool {
        return lhs.number.toDecimal() == rhs.number.toDecimal()
    }

    let number: DSNumber
    init(_ number: DSNumber) {
        self.number = number
    }
}
