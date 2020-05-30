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
    @discardableResult func lengthNotFromMessage(_ message: String) -> ValueValidator

    // including
    @discardableResult func length(upTo length: Int) -> ValueValidator
    @discardableResult func lengthNotUpToMessage(_ message: String) -> ValueValidator

    @discardableResult func length(exact length: Int) -> ValueValidator
    @discardableResult func lengthNoExactMessage(_ message: String) -> ValueValidator

    // including
    @discardableResult func length(from: Int, to: Int) -> ValueValidator
    @discardableResult func lengthNotFromToMessage(_ message: String) -> ValueValidator

    @discardableResult func match(_ string: String) -> ValueValidator
    @discardableResult func notMatchMessage(_ message: String) -> ValueValidator

    @discardableResult func differ(_ string: String) -> ValueValidator
    @discardableResult func notDifferMessage(_ message: String) -> ValueValidator

    @discardableResult func decimal() -> ValueValidator
    @discardableResult func notDecimalMessage(_ message: String) -> ValueValidator

    @discardableResult func hasEmoji() -> ValueValidator
    @discardableResult func noEmojiMessage(_ message: String) -> ValueValidator

    @discardableResult func hasNoEmoji() -> ValueValidator
    @discardableResult func hasEmojiMessage(_ message: String) -> ValueValidator
}
