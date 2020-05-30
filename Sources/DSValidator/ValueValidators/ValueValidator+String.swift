//
//  DSValueValidator+String.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 3/14/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation


public protocol StringValueValidator {
    // including
    @discardableResult func length(from length: Int) -> ValueValidator
    @discardableResult func lengthNotFromErrorMessage(_ message: String) -> ValueValidator

    // including
    @discardableResult func length(upTo length: Int) -> ValueValidator
    @discardableResult func lengthNotUpToErrorMessage(_ message: String) -> ValueValidator

    @discardableResult func length(exact length: Int) -> ValueValidator
    @discardableResult func lengthNoExactErrorMessage(_ message: String) -> ValueValidator

    // including
    @discardableResult func length(from: Int, to: Int) -> ValueValidator
    @discardableResult func lengthNotFromToErrorMessage(_ message: String) -> ValueValidator

    @discardableResult func match(_ string: String) -> ValueValidator
    @discardableResult func notMatchErrorMessage(_ message: String) -> ValueValidator

    @discardableResult func differ(_ string: String) -> ValueValidator
    @discardableResult func notDifferErrorMessage(_ message: String) -> ValueValidator

    @discardableResult func decimal() -> ValueValidator
    @discardableResult func notDecimalErrorMessage(_ message: String) -> ValueValidator

    @discardableResult func hasEmoji() -> ValueValidator
    @discardableResult func noEmojiErrorMessage(_ message: String) -> ValueValidator

    @discardableResult func hasNoEmoji() -> ValueValidator
    @discardableResult func hasEmojiErrorMessage(_ message: String) -> ValueValidator
}
