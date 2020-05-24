//
//  ValidationError+Extensions.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/24/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

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


extension ValidationError {
    static func objectOfNotSupportedType() -> ValidationError {
        return ValidationError(.objectOfNotSupportedType, message:  Constants.objectOfNotSupportedTypeErrorMessage)
    }

    static func valueNotFound() -> ValidationError {
        return ValidationError(.valueNotFound, message: Constants.valueNotFoundErrorMessage)
    }
}
