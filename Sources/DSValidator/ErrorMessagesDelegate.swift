//
//  ErrorMessagesDelegate.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/23/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

public protocol ErrorMessagesDelegate {
    func errorMessage(by code: ValidationError.Code, for property: Property) -> String?
}
