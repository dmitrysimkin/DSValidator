//
//  DSValueValidator+Collection.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/3/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation


public protocol CollectionValueValidator {
    @discardableResult func includes<T: Equatable>(_ element: T) -> ValueValidator
    @discardableResult func excludes<T: Equatable>(_ element: T) -> ValueValidator
    @discardableResult func includedIn(_ collection: DSCollection) -> ValueValidator
    @discardableResult func excludedFrom(_ collection: DSCollection) -> ValueValidator

    @discardableResult func notIncludesMessage(_ message: String) -> ValueValidator
    @discardableResult func notExcludesMessage(_ message: String) -> ValueValidator
    @discardableResult func notIncludedInMessage(_ message: String) -> ValueValidator
    @discardableResult func notExcludedFromMessage(_ message: String) -> ValueValidator

}
