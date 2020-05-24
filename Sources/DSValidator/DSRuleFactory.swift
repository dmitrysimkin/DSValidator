//
//  DSRuleFactory.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/22/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

public typealias Property = String

public class DS {
    private static let defaultPropertyName = "Value"
    public static func rule(messagesProvider: ErrorMessagesDelegate = DSDefaultMessagesProvider()) -> ValueValidator {
        return DSValueValidator(name: DS.defaultPropertyName, defaultMessagesProvider: messagesProvider)
    }

    public static func rule(for name: Property,
                            messagesProvider: ErrorMessagesDelegate = DSDefaultMessagesProvider()) -> ValueValidator {
        return DSValueValidator(name: name, defaultMessagesProvider: messagesProvider)
    }
}
