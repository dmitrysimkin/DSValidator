//
//  ValidationError.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/23/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

/// Validation Error
public struct ValidationError: Error {
    /// Code of the validatio error
    public enum Code {

        // common
        case required
        case empty
        case wrongType // passed value of wrong type, e.g. expected to validate 'Int' but 'String' value passed
        case objectOfNotSupportedType // type of the object to validate is not supported
        case valueNotFound // value by provided 'property' is not found
        case invalidArgument // provided argument parameter(s) is(are) inconsitant

        /// Custom error code. Designed expecially for custom validation rules
        case custom(Int)

        // Strings
        case lengthNotFrom
        case lengthNotUpTo
        case lengthNotExact
        case lengthNotFromTo
        case notMatch
        case notDiffer
        case notDecimal
        case hasEmoji
        case noEmoji

        // Numbers
        case notGreater
        case notGreaterOrEqual
        case notSmaller
        case notSmallerOrEqual
        case notEqual
        case notFalse
        case notTrue

        // Date
        case notEarlierThan
        case notLaterThan
        case notEarlierThanOrEqualTo
        case notLaterThanOrEqualTo
        case notBetweenDates

        // Syntax
        case notEmail
        case notName
        case notHTTP
        case notFile
        case notWebSocket
        case notMatchToRegexp
        case notIPv4
        case notIPv6
        case notDomain
        case notGeoCoordinate

        // CreditCard TODO: ?
        //        case notValidCreditCardNumber
        //        case notValidCreditCardExpirationDate

        // Collections
        case notIncludes
        case notExcludes
        case notIncludedIn
        case notExcludedFrom
    }

    /// error code
    public let code: Code

    var message: String?

    init(_ code: Code, message: String? = nil) {
        self.code = code
        self.message = message
    }
}

extension ValidationError.Code: Hashable { }
