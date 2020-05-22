//
//  DSDate.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/17/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

/// Protocol to simplify date validation interface
/// by wrapping up Date and TimeInterval
public protocol DSDate {
    func value() -> Date
}
