//
//  MockValueValidator.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/23/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation
@testable import DSValidator

let DefaultValueValidatorName = "Validator"


let underPG13ErrorCode = 1111

extension ValueValidator {
    @discardableResult
    func emptyTestRule() -> ValueValidator {
        addValidation(named: DefaultValueValidatorName, block: { _ in return .empty })
    }

    @discardableResult
    func fail(_ code: ValidationError.Code) -> ValueValidator {
        addValidation(named: DefaultValueValidatorName, block: { _ in return code })
    }

    @discardableResult
    func pg13() -> ValueValidator {
        addValidation(named: "PG-13") { (age) -> ValidationError.Code? in
            guard let age = age as? Int else { return .wrongType }
            let above13 = age >= 13
            return above13 ? nil : .custom(underPG13ErrorCode)
        }
    }

    @discardableResult
    func notPG13ErrorMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .custom(underPG13ErrorCode))
    }
}
