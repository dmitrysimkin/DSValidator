//
//  DSRuleFactory.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/22/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

public class DS {
    private static let defaultPropertyName = "Value"
    public static func rule(for name: String? = nil,
                            defaultMessagesProvder: ErrorMessagesDelegate = DSDefaultMessagesProvider()) -> ValueValidator {
        let name = name ?? DS.defaultPropertyName
        return DSValueValidator(name: name, defaultMessagesProvder: defaultMessagesProvder)
    }
}
