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

    @discardableResult func notIncludesErrorMessage(_ message: String) -> ValueValidator
    @discardableResult func notExcludesErrorMessage(_ message: String) -> ValueValidator
    @discardableResult func notIncludedInErrorMessage(_ message: String) -> ValueValidator
    @discardableResult func notExcludedFromErrorMessage(_ message: String) -> ValueValidator

}
