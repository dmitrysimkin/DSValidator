//
//  MockErrorMessagesDelegate.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 2/28/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

final class MockErrorMessagesDelegate: ErrorMessagesDelegate {
    lazy var errorMessageHook = mock(errorMessage)
    func errorMessage(by code: ValidationError.Code, for valueName: String) -> String? {
        return errorMessageHook?(code, valueName) ?? nil
    }
}
