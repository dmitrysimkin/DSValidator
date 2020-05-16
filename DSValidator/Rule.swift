//
//  Rule.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/22/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

public typealias ValidationBlock = (Any?) -> ValidationError.Code?

public protocol Rule {
    var name: String { get }
    var validationBlock: ValidationBlock { get }
}
