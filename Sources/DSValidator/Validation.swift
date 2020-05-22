//
//  Validation.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/22/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

public typealias ValidationBlock = (Any?) -> ValidationError.Code?

public protocol Validation {
    var name: String { get }
    var block: ValidationBlock { get }
}
