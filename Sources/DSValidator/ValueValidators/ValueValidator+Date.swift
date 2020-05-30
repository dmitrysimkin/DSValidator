//
//  DSValueValidator+Date.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 3/1/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation


public protocol DateValueValidator {
    @discardableResult func earlierThan(_ date: DSDate) -> ValueValidator
    @discardableResult func notEarlierThenErrorMessage(_ message: String) -> ValueValidator

    @discardableResult func laterThan(_ date: DSDate) -> ValueValidator
    @discardableResult func notLaterThanErrorMessage(_ message: String) -> ValueValidator

    @discardableResult func earlierOrEqualTo(_ date: DSDate) -> ValueValidator
    @discardableResult func notEarlierOrEqualToErrorMessage(_ message: String) -> ValueValidator

    @discardableResult func laterOrEqualTo(_ date: DSDate) -> ValueValidator
    @discardableResult func notLaterOrEqualToErrorMessage(_ message: String) -> ValueValidator

    @discardableResult func betweenDates(_ fromDate: DSDate, _ toDate: DSDate) -> ValueValidator
    @discardableResult func betweenDatesNotIncluding(_ fromDate: DSDate, _ toDate: DSDate) -> ValueValidator
    @discardableResult func notBetweenDatesErrorMessage(_ message: String) -> ValueValidator
}
