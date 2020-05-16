//
//  DefaultMessagesProvider.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 3/9/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

public class DSDefaultMessagesProvider: ErrorMessagesDelegate {

    var messages = [ValidationError.Code: String]()

    public init() {
        setup()
    }

    public func errorMessageByCode(_ code: ValidationError.Code, for valueName: String) -> String? {
        guard var message = messages[code] else { return nil }
        message = "\(valueName) \(message)"
        return message
    }
}

extension DSDefaultMessagesProvider {
    private func setup() {
        messages[.required] = "is required."
        messages[.empty] = "is empty."
        messages[.wrongType] = "is wrong type."
        messages[.invalidArgument] = "" // TODO: message with format is better here, not just 'name + message'
        // Date
        messages[.notEarlierThan] = "isn't earlier than compared date."
        messages[.notLaterThan] = "isn't later than compared date."
        messages[.notEarlierThanOrEqualTo] = "isn't earlier than or equal to compared date."
        messages[.notLaterThanOrEqualTo] = "isn't later than or equal to compared date."
        messages[.notBetweenDates] = "isn't between given dates."

        //String
        messages[.lengthNotFrom] = "is not longer enough from provided limit."
        messages[.lengthNotUpTo] = "is longer then provided limit."
        messages[.lengthNotExact] = "is not exact length."
        messages[.lengthNotFromTo] = "is not in provided range (from - to)."
        messages[.notMatch] = "doesn't match."
        messages[.notDiffer] = "doesn't differ."
        messages[.notDecimal] = "is not decimal number."
        messages[.noEmoji] = "doesn't contain emoji."
        messages[.noEmoji] = "contains emoji."

        // Numbers
        messages[.notGreater] = "is not greater than provided limit."
        messages[.notGreaterOrEqual] = "is not greater or equal than provided limit."
        messages[.notSmaller] = "is not smaller than provided limit."
        messages[.notSmallerOrEqual] = "is not smaller or equal than provided limit."
        messages[.notEqual] = "is not equal."
        messages[.notFalse] = "is not false."
        messages[.notTrue] = "is not true."

        // Syntax
        messages[.notEmail] = "is not valid email."
        messages[.notName] = "is not valid name."
        messages[.notHTTP] = "is not valid HTTP url."
        messages[.notFile] = "is not valid File url."
        messages[.notWebSocket] = "is not valid WebSocket url."
        messages[.notIPv4] = "is not valid IPv4 address."
        messages[.notIPv6] = "is not valid IPv6 address."
        messages[.notMatchToRegexp] = "does not match to regular expression."
        messages[.notDomain] = "is not valid domain name."
        messages[.notGeoCoordinate] = "is not valid geo coordinate."

        // Collection
        messages[.notIncludes] = "doesn't include provided value."
        messages[.notExcludes] = "doesn't exclude provided value."
        messages[.notIncludedIn] = "isn't included in provided collection."
        messages[.notExcludedFrom] = "isn't excluded from provided collection."
    }
}
