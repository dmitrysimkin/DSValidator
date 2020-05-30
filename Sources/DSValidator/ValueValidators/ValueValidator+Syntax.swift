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
    @discardableResult func syntax(_ syntax: DSSyntax) -> ValueValidator
    @discardableResult func regex(_ pattern: String, options: NSRegularExpression.Options) -> ValueValidator

    @discardableResult func wrongSyntaxErrorMessage(_ syntax: DSSyntax, message: String) -> ValueValidator
    @discardableResult func wrongRegexpErrorMessage(_ message: String) -> ValueValidator
}
