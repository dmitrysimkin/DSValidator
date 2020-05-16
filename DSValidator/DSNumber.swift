//
//  DSNumber.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/2/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

public protocol DSNumber {
    func toDecimal() -> Decimal
}

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

// MARK: - Extensions

extension Int: DSNumber {
    public func toDecimal() -> Decimal { Decimal(self) }
}

extension Int8: DSNumber {
    public func toDecimal() -> Decimal { Decimal(self) }
}

extension Int16: DSNumber {
    public func toDecimal() -> Decimal { Decimal(self) }
}

extension Int32: DSNumber {
    public func toDecimal() -> Decimal { Decimal(self) }
}

extension Int64: DSNumber {
    public func toDecimal() -> Decimal { Decimal(self) }
}

extension UInt: DSNumber {
    public func toDecimal() -> Decimal { Decimal(self) }
}

extension UInt8: DSNumber {
    public func toDecimal() -> Decimal { Decimal(self) }
}

extension UInt16: DSNumber {
    public func toDecimal() -> Decimal { Decimal(self) }
}

extension UInt32: DSNumber {
    public func toDecimal() -> Decimal { Decimal(self) }
}

extension UInt64: DSNumber {
    public func toDecimal() -> Decimal { Decimal(self) }
}

extension Float: DSNumber {
    public func toDecimal() -> Decimal { return NSNumber(value: self).decimalValue }
}

extension Decimal: DSNumber {
    public func toDecimal() -> Decimal { return self }
}

extension NSNumber: DSNumber {
    public func toDecimal() -> Decimal { return decimalValue }
}

extension Double: DSNumber {
    public func toDecimal() -> Decimal { return NSNumber(value: self).decimalValue }

}
