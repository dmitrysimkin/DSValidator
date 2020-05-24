//
//  DSNumber+Extensions.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/17/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

extension Int: DSNumber {
    public func value() -> Decimal { Decimal(self) }
}

extension Int8: DSNumber {
    public func value() -> Decimal { Decimal(self) }
}

extension Int16: DSNumber {
    public func value() -> Decimal { Decimal(self) }
}

extension Int32: DSNumber {
    public func value() -> Decimal { Decimal(self) }
}

extension Int64: DSNumber {
    public func value() -> Decimal { Decimal(self) }
}

extension UInt: DSNumber {
    public func value() -> Decimal { Decimal(self) }
}

extension UInt8: DSNumber {
    public func value() -> Decimal { Decimal(self) }
}

extension UInt16: DSNumber {
    public func value() -> Decimal { Decimal(self) }
}

extension UInt32: DSNumber {
    public func value() -> Decimal { Decimal(self) }
}

extension UInt64: DSNumber {
    public func value() -> Decimal { Decimal(self) }
}

extension Float: DSNumber {
    public func value() -> Decimal { return NSNumber(value: self).decimalValue }
}

extension Decimal: DSNumber {
    public func value() -> Decimal { return self }
}

extension NSNumber: DSNumber {
    public func value() -> Decimal { return decimalValue }
}

extension Double: DSNumber {
    public func value() -> Decimal { return NSNumber(value: self).decimalValue }
}
