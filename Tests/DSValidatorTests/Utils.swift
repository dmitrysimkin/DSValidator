//
//  Utils.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 2/28/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation
import XCTest


func mock<T>(_ value: T) -> T? {
    return nil
}

extension XCTestExpectation {
    convenience init(isInverted: Bool) {
        self.init()
        self.isInverted = isInverted
    }

    convenience init(callsCount: Int) {
        self.init()
        self.expectedFulfillmentCount = callsCount
        self.assertForOverFulfill = true
    }
}

extension Date: ExpressibleByStringLiteral {
    private static let supportedFormatters = [
        "dd.MM.yyyy",
        "dd.MM.yyyy HH:mm:ss"
    ]

    public init(stringLiteral value: String) {
        let formatter = DateFormatter()
        for format in Date.supportedFormatters {
            formatter.dateFormat = format
            if let date = formatter.date(from: value) {
                self = date
                return
            }
        }
        fatalError("Not supported string literal to create date: \(value)")
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension String: DSDate {
    public func value() -> Date {
        return Date(stringLiteral: self)
    }
}

extension XCTestCase {
    func makeDefaultValidator() -> DSValueValidator {
        return DSValueValidator(property: DefaultValueValidatorName, defaultMessagesProvider: MockErrorMessagesDelegate())
    }
}
