//
//  ValidationError.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/23/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

public struct ValidationError: Error {
    public enum Code {

        // common
        case required
        case empty
        case wrongType // passed value of wrong type, e.g. expected to validate 'Int' but 'String' value passed
        case objectOfNotSupportedType // type of the object to validate is not supported
        case valueNotFound // value by provided 'name' is not found
        case invalidArgument // provided argument parameter(s) is(are) inconsitant

        // custom
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

        //        // CreditCard
        //        case notValidCreditCardNumber
        //        case notValidCreditCardExpirationDate
        //
        //        // Data
        //        case wrongMIMEType
        //        case wrongMediaType
        //        case dataTooBig
        //        case dataTooSmall

        // Collections
        case notIncludes
        case notExcludes
        case notIncludedIn
        case notExcludedFrom
    }

    let code: Code
    private var message: String?

    init(_ code: Code, message: String? = nil) {
        self.code = code
        self.message = message
    }
}

extension ValidationError: LocalizedError {
    private static let DefaultLocalizedMessage = "Validation Error"
    public var errorDescription: String? { message ?? ValidationError.DefaultLocalizedMessage }
}

extension ValidationError: Equatable {
    public static func == (lhs: ValidationError, rhs: ValidationError) -> Bool {
        guard lhs.message == rhs.message else {
            return false
        }
        switch (lhs.code, rhs.code) {
        case (.custom(let lhsCustomCode), .custom(let rhsCustomCode)):
            return lhsCustomCode == rhsCustomCode

        // Common
        case (.required, .required),
             (.empty, .empty),
             (.wrongType, .wrongType),
             (.invalidArgument, .invalidArgument),
             (.objectOfNotSupportedType, .objectOfNotSupportedType),
             (.valueNotFound, .valueNotFound),

        // Date
        (.notEarlierThan, .notEarlierThan),
        (.notLaterThan, .notLaterThan),
        (.notEarlierThanOrEqualTo, .notEarlierThanOrEqualTo),
        (.notLaterThanOrEqualTo, .notLaterThanOrEqualTo),
        (.notBetweenDates, .notBetweenDates),

        // String
        (.lengthNotFrom, .lengthNotFrom),
        (.lengthNotUpTo, .lengthNotUpTo),
        (.lengthNotExact, .lengthNotExact),
        (.lengthNotFromTo, .lengthNotFromTo),
        (.notMatch, .notMatch),
        (.notDiffer, .notDiffer),
        (.notDecimal, .notDecimal),
        (.noEmoji, .noEmoji),
        (.hasEmoji, .hasEmoji),

            // Syntax
        (.notEmail, .notEmail),
        (.notName, .notName),
        (.notHTTP, .notHTTP),
        (.notFile, .notFile),
        (.notWebSocket, .notWebSocket),
        (.notIPv4, .notIPv4),
        (.notIPv6, .notIPv6),
        (.notMatchToRegexp, .notMatchToRegexp),
        (.notDomain, .notDomain),
        (.notGeoCoordinate, .notGeoCoordinate),

            // Number
        (.notGreater, .notGreater),
        (.notGreaterOrEqual, .notGreaterOrEqual),
        (.notSmaller, .notSmaller),
        (.notSmallerOrEqual, .notSmallerOrEqual),
        (.notEqual, .notEqual),
        (.notTrue, .notTrue),
        (.notFalse, .notFalse),

        // Collection
        (.notIncludes, .notIncludes),
        (.notExcludes, .notExcludes),
        (.notIncludedIn, .notIncludedIn),
        (.notExcludedFrom, .notExcludedFrom):
            return true
            
        default:
            return false
        }
    }
}

extension ValidationError.Code: Hashable { }

extension ValidationError {
    static func objectOfNotSupportedType() -> ValidationError {
        return ValidationError(.objectOfNotSupportedType, message:  Constants.objectOfNotSupportedTypeErrorMessage)
    }

    static func valueNotFound() -> ValidationError {
        return ValidationError(.valueNotFound, message: Constants.valueNotFoundErrorMessage)
    }
}
