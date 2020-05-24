//
//  DSNumber.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/2/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

/// Protocol to simplify numbers validation interface
/// by wrapping up number types (e.g. Float, Double, Decimal, Int variations)
public protocol DSNumber {
    func value() -> Decimal
}
