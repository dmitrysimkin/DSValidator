//
//  Validation.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/22/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

/// Block that performs some validation
public typealias ValidationBlock = (Any?) -> ValidationError.Code?

/// Class that represents one single validation iteration, such as 'required', 'smallerThan(...)', etc.
public protocol Validation {
    /// Name that describes validation
    var name: String { get }
    /// Block that does actual validation
    var block: ValidationBlock { get }
}
