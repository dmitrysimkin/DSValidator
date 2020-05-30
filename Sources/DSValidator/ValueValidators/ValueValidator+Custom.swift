//
//  CustomValueValidator.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/30/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

public protocol CustomValidation {
    @discardableResult func addValidation(named: String, block: @escaping ValidationBlock) -> ValueValidator
    @discardableResult func setErrorMessage(_ message: String, for code: ValidationError.Code) -> ValueValidator
}
