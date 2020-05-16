//
//  DSDate+Extensions.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/17/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

extension Date: DSDate {
    public func value() -> Date { return self }
}

extension TimeInterval: DSDate {
    public func value() -> Date {
        let date = Date(timeIntervalSince1970: self)
        return date
    }
}
