//
//  DSValueValidator+Syntax.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 3/29/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import UIKit
import Foundation


public protocol SyntaxValueValidator {
    @discardableResult func syntax(_ syntax: Syntax) -> ValueValidator
    @discardableResult func regex(_ pattern: String, options: NSRegularExpression.Options) -> ValueValidator

    @discardableResult func wrongSyntaxMessage(_ syntax: Syntax, message: String) -> ValueValidator
    @discardableResult func wrongRegexpMessage(_ message: String) -> ValueValidator
}

extension ValueValidator {
    @discardableResult func syntax(_ syntax: Syntax) -> ValueValidator {
        switch syntax {
        case .email:    addStringRule(with: Names.syntaxEmail) { $0.isEmail ? nil : .notEmail }
        case .name:     addStringRule(with: Names.syntaxName) { $0.isName ? nil : .notName }
        case .http:     addStringRule(with: Names.syntaHTTP) { $0.isHttp ? nil : .notHTTP }
        case .file:     addStringRule(with: Names.syntaFile) { $0.isFile ? nil : .notFile }
        case .webSocket: addStringRule(with: Names.syntaxWebSocket) { $0.isWebSocket ?  nil : .notWebSocket }
        case .IPv4: addStringRule(with: Names.syntaxIPv4) { $0.isIPv4 ?  nil : .notIPv4 }
        case .IPv6: addStringRule(with: Names.syntaxIPv6) { $0.isIPv6 ?  nil : .notIPv6 }
        case .domain: addStringRule(with: Names.syntaxDomain) { $0.isDomain ? nil : .notDomain }
        case .geoCoordinate: addStringRule(with: Names.syntaxGeoCoordinate) { $0.isGeoCoordinate ? nil : .notGeoCoordinate }
        }
        return self
    }

    @discardableResult func regex(_ pattern: String, options: NSRegularExpression.Options) -> ValueValidator {
        addStringRule(with: Names.syntaxRegexp) { (value) -> ValidationError.Code? in
            let valid: Bool
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: options)
                let range = NSRange(location: 0, length: value.utf16.count)
                let mathces = regex.matches(in: value, range: range)
                valid = mathces.first != nil
            } catch {
                valid = false
            }
            return valid ? nil : .notMatchToRegexp
        }
    }

    @discardableResult
    func addStringRule(with name: String, block: @escaping (String) -> ValidationError.Code?) -> ValueValidator {
        addRule(with: name) { [weak self] (value) -> ValidationError.Code? in
            guard let value = self?.isString(from: value) else { return .wrongType }
            return block(value)
        }
    }

    @discardableResult func wrongSyntaxMessage(_ syntax: Syntax, message: String) -> ValueValidator {
        setErrorMessage(message, for: syntax.code())
    }

    @discardableResult func wrongRegexpMessage(_ message: String) -> ValueValidator {
        setErrorMessage(message, for: .notMatchToRegexp)
    }
}

private struct Names {
    static let syntaxEmail = "Syntax email"
    static let syntaxName = "Syntax name"
    static let syntaHTTP = "Syntax HTTP"
    static let syntaFile = "Syntax HTTP"
    static let syntaxWebSocket = "Syntax HTTP"
    static let syntaxIPv4 = "Syntax IPv4"
    static let syntaxIPv6 = "Syntax IPv6"
    static let syntaxRegexp = "Syntax Regexp"
    static let syntaxDomain = "Syntax Domain"
    static let syntaxGeoCoordinate = "Syntax Geo Coordinate"
}
