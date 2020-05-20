//
//  ValueValidatorDateTests.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 3/14/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import XCTest
@testable import DSValidator

class ValueValidatorDateTests: XCTestCase {

    let validator = DSValueValidator(name: DefaultValueValidatorName, defaultMessagesProvder: MockErrorMessagesDelegate())

    // MARK: - Earlier then
    func testEarlierThen_Success() {
        validator.earlierThan("21.07.2012 12:00:00")
        let secondEarlier: Date = "21.07.2012 11:59:59"
        XCTAssertNil(validator.validate(value: secondEarlier))
        let minuteEarlier: Date = "21.07.2012 11:59:00"
        XCTAssertNil(validator.validate(value: minuteEarlier))
        let hoursEarlier: Date = "21.07.2012 02:32:31"
        XCTAssertNil(validator.validate(value: hoursEarlier))
        let dayEarlier: Date = "20.07.2012"
        XCTAssertNil(validator.validate(value: dayEarlier))
        let weakEarlier: Date = "10.07.2012"
        XCTAssertNil(validator.validate(value: weakEarlier))
        let monthEarlier: Date = "21.06.2012"
        XCTAssertNil(validator.validate(value: monthEarlier))
        let halfYearEariler: Date = "01.01.2012"
        XCTAssertNil(validator.validate(value: halfYearEariler))
        let threeYaersEarlier: Date = "21.07.2009"
        XCTAssertNil(validator.validate(value: threeYaersEarlier))
        let manyYaersEarlier: Date = "13.02.222"
        XCTAssertNil(validator.validate(value: manyYaersEarlier))
    }

    func testEarlierThen_Fail() {
        validator.earlierThan("15.06.2034 09:00:00")
        let exact: Date = "15.06.2034 09:00:00"
        XCTAssertNotNil(validator.validate(value: exact))
        XCTAssertEqual(validator.validate(value: exact)?.code, .notEarlierThan)
        let second: Date = "15.06.2034 09:00:01"
        XCTAssertNotNil(validator.validate(value: second))
        let minute: Date = "15.06.2034 09:01:00"
        XCTAssertNotNil(validator.validate(value: minute))
        let hours: Date = "15.06.2034 23:23:13"
        XCTAssertNotNil(validator.validate(value: hours))
        let days: Date = "17.06.2034 09:00:00"
        XCTAssertNotNil(validator.validate(value: days))
        let month: Date = "15.09.2034 09:00:00"
        XCTAssertNotNil(validator.validate(value: month))
        let years: Date = "15.06.2111 09:00:00"
        XCTAssertNotNil(validator.validate(value: years))
    }

    func testEarilerThenWrongType() {
        validator.earlierThan("15.06.2034 09:00:00")
        XCTAssertEqual(validator.validate(value: 2), ValidationError(.wrongType))
    }

    // MARK: - EarlierThenOrEqual
    func testEarlierThenOrEqual_Success() {
        validator.earlierOrEqualTo("21.07.2012 12:00:00")
        let exact: Date = "21.07.2012 12:00:00"
        XCTAssertNil(validator.validate(value: exact))
        let secondEarlier: Date = "21.07.2012 11:59:59"
        XCTAssertNil(validator.validate(value: secondEarlier))
        let minuteEarlier: Date = "21.07.2012 11:59:00"
        XCTAssertNil(validator.validate(value: minuteEarlier))
        let hoursEarlier: Date = "21.07.2012 02:32:31"
        XCTAssertNil(validator.validate(value: hoursEarlier))
        let dayEarlier: Date = "20.07.2012"
        XCTAssertNil(validator.validate(value: dayEarlier))
        let weakEarlier: Date = "10.07.2012"
        XCTAssertNil(validator.validate(value: weakEarlier))
        let monthEarlier: Date = "21.06.2012"
        XCTAssertNil(validator.validate(value: monthEarlier))
        let halfYearEariler: Date = "01.01.2012"
        XCTAssertNil(validator.validate(value: halfYearEariler))
        let threeYaersEarlier: Date = "21.07.2009"
        XCTAssertNil(validator.validate(value: threeYaersEarlier))
        let manyYaersEarlier: Date = "13.02.222"
        XCTAssertNil(validator.validate(value: manyYaersEarlier))
    }

    func testEarlierOrEqual_Fail() {
        validator.earlierOrEqualTo("15.06.2034 09:00:00")
        let second: Date = "15.06.2034 09:00:01"
        XCTAssertNotNil(validator.validate(value: second))
        XCTAssertEqual(validator.validate(value: second)?.code, .notEarlierThanOrEqualTo)
        let minute: Date = "15.06.2034 09:01:00"
        XCTAssertNotNil(validator.validate(value: minute))
        let hours: Date = "15.06.2034 23:23:13"
        XCTAssertNotNil(validator.validate(value: hours))
        let days: Date = "17.06.2034 09:00:00"
        XCTAssertNotNil(validator.validate(value: days))
        let month: Date = "15.09.2034 09:00:00"
        XCTAssertNotNil(validator.validate(value: month))
        let years: Date = "15.06.2111 09:00:00"
        XCTAssertNotNil(validator.validate(value: years))
    }

    func testEarilerThenOrEqualWrongType() {
        validator.earlierOrEqualTo("15.06.2034 09:00:00")
        XCTAssertEqual(validator.validate(value: 2), ValidationError(.wrongType))
    }

    // MARK: - LaterThen
    func testLaterThen_Success() {
        validator.laterThan("15.06.2034 09:00:00")
        let second: Date = "15.06.2034 09:00:01"
        XCTAssertNil(validator.validate(value: second))
        let minute: Date = "15.06.2034 09:01:00"
        XCTAssertNil(validator.validate(value: minute))
        let hours: Date = "15.06.2034 23:23:13"
        XCTAssertNil(validator.validate(value: hours))
        let days: Date = "17.06.2034 09:00:00"
        XCTAssertNil(validator.validate(value: days))
        let month: Date = "15.09.2034 09:00:00"
        XCTAssertNil(validator.validate(value: month))
        let years: Date = "15.06.2111 09:00:00"
        XCTAssertNil(validator.validate(value: years))
    }

    func testLaterThen_Fail() {
        validator.laterThan("21.07.2012 12:00:00")
        let exact: Date = "21.07.2012 12:00:00"
        XCTAssertNotNil(validator.validate(value: exact))
        XCTAssertEqual(validator.validate(value: exact)?.code, .notLaterThan)
        let secondEarlier: Date = "21.07.2012 11:59:59"
        XCTAssertNotNil(validator.validate(value: secondEarlier))
        let minuteEarlier: Date = "21.07.2012 11:59:00"
        XCTAssertNotNil(validator.validate(value: minuteEarlier))
        let hoursEarlier: Date = "21.07.2012 02:32:31"
        XCTAssertNotNil(validator.validate(value: hoursEarlier))
        let dayEarlier: Date = "20.07.2012"
        XCTAssertNotNil(validator.validate(value: dayEarlier))
        let weakEarlier: Date = "10.07.2012"
        XCTAssertNotNil(validator.validate(value: weakEarlier))
        let monthEarlier: Date = "21.06.2012"
        XCTAssertNotNil(validator.validate(value: monthEarlier))
        let halfYearEariler: Date = "01.01.2012"
        XCTAssertNotNil(validator.validate(value: halfYearEariler))
        let threeYaersEarlier: Date = "21.07.2009"
        XCTAssertNotNil(validator.validate(value: threeYaersEarlier))
        let manyYaersEarlier: Date = "13.02.222"
        XCTAssertNotNil(validator.validate(value: manyYaersEarlier))
    }

    func testLaterThenWrongType() {
        validator.laterThan("15.06.2034 09:00:00")
        XCTAssertEqual(validator.validate(value: 2), ValidationError(.wrongType))
    }

    // MARK: - LaterOrEqual
    func testLaterOrEqual_Success() {
        validator.laterOrEqualTo("15.06.2034 09:00:00")
        let exact: Date = "15.06.2034 09:00:00"
        XCTAssertNil(validator.validate(value: exact))
        let second: Date = "15.06.2034 09:00:01"
        XCTAssertNil(validator.validate(value: second))
        let minute: Date = "15.06.2034 09:01:00"
        XCTAssertNil(validator.validate(value: minute))
        let hours: Date = "15.06.2034 23:23:13"
        XCTAssertNil(validator.validate(value: hours))
        let days: Date = "17.06.2034 09:00:00"
        XCTAssertNil(validator.validate(value: days))
        let month: Date = "15.09.2034 09:00:00"
        XCTAssertNil(validator.validate(value: month))
        let years: Date = "15.06.2111 09:00:00"
        XCTAssertNil(validator.validate(value: years))
    }

    func testLaterOrEqual_Fail() {
        validator.laterOrEqualTo("21.07.2012 12:00:00")
        let secondEarlier: Date = "21.07.2012 11:59:59"
        XCTAssertNotNil(validator.validate(value: secondEarlier))
        XCTAssertEqual(validator.validate(value: secondEarlier)?.code, .notLaterThanOrEqualTo)
        let minuteEarlier: Date = "21.07.2012 11:59:00"
        XCTAssertNotNil(validator.validate(value: minuteEarlier))
        let hoursEarlier: Date = "21.07.2012 02:32:31"
        XCTAssertNotNil(validator.validate(value: hoursEarlier))
        let dayEarlier: Date = "20.07.2012"
        XCTAssertNotNil(validator.validate(value: dayEarlier))
        let weakEarlier: Date = "10.07.2012"
        XCTAssertNotNil(validator.validate(value: weakEarlier))
        let monthEarlier: Date = "21.06.2012"
        XCTAssertNotNil(validator.validate(value: monthEarlier))
        let halfYearEariler: Date = "01.01.2012"
        XCTAssertNotNil(validator.validate(value: halfYearEariler))
        let threeYaersEarlier: Date = "21.07.2009"
        XCTAssertNotNil(validator.validate(value: threeYaersEarlier))
        let manyYaersEarlier: Date = "13.02.222"
        XCTAssertNotNil(validator.validate(value: manyYaersEarlier))
    }

    func testLaterOrEqualWrongType() {
        validator.laterOrEqualTo("15.06.2034 09:00:00")
        XCTAssertEqual(validator.validate(value: 2), ValidationError(.wrongType))
    }

    // MARK: - BetweenDates
    func testBetweenDatesSecondsIncluding() {
        validator.betweenDates("14.03.2020 15:43:10", "14.03.2020 15:43:15")
        XCTAssertNil(validator.validate(value: "14.03.2020 15:43:10" as Date))
        XCTAssertNil(validator.validate(value: "14.03.2020 15:43:11" as Date))
        XCTAssertNil(validator.validate(value: "14.03.2020 15:43:12" as Date))
        XCTAssertNil(validator.validate(value: "14.03.2020 15:43:14" as Date))
        XCTAssertNil(validator.validate(value: "14.03.2020 15:43:15" as Date))
        XCTAssertNotNil(validator.validate(value: "14.03.2020 15:43:09" as Date))
        XCTAssertNotNil(validator.validate(value: "14.03.2020 15:43:16"as Date))
        XCTAssertEqual(validator.validate(value: "14.03.2020 15:43:16" as Date)?.code, .notBetweenDates)
    }

    func testBetweenDatesMonthIncluding() {
        validator.betweenDates("14.03.2020", "14.04.2020")
        // Equalt to range
        XCTAssertNil(validator.validate(value: "14.03.2020 00:00:00" as Date))
        XCTAssertNil(validator.validate(value: "14.04.2020 00:00:00" as Date))
        // 1 sec inside
        XCTAssertNil(validator.validate(value: "14.03.2020 00:00:01" as Date))
        XCTAssertNil(validator.validate(value: "14.03.2020 23:59:59" as Date))
        // inside
        XCTAssertNil(validator.validate(value: "14.03.2020 01:43:15" as Date))
        XCTAssertNil(validator.validate(value: "13.04.2020 23:43:15" as Date))
        XCTAssertNil(validator.validate(value: "31.03.2020 12:43:15" as Date))
        // 1 sec outside
        XCTAssertNotNil(validator.validate(value: "14.02.2020 23:59:59" as Date))
        XCTAssertNotNil(validator.validate(value: "14.04.2020 00:00:01"as Date))
        XCTAssertEqual(validator.validate(value: "14.04.2020 00:00:01" as Date)?.code, .notBetweenDates)
    }

    func testBetweenDatesDaysNotIncluding() {
        validator.betweenDatesNotIncluding("07.07.2020", "14.07.2020")
        // Equalt to range
        XCTAssertNotNil(validator.validate(value: "07.07.2020 00:00:00" as Date))
        XCTAssertNotNil(validator.validate(value: "14.07.2020 00:00:00" as Date))
        XCTAssertEqual(validator.validate(value: "14.07.2020 00:00:00" as Date)?.code, .notBetweenDates)
        // 1 sec inside
        XCTAssertNil(validator.validate(value: "07.07.2020 00:00:01" as Date))
        XCTAssertNil(validator.validate(value: "13.07.2020 23:59:59" as Date))
        // inside
        XCTAssertNil(validator.validate(value: "08.07.2020" as Date))
        XCTAssertNil(validator.validate(value: "10.07.2020" as Date))
        XCTAssertNil(validator.validate(value: "12.07.2020" as Date))
        // 1 sec outside
        XCTAssertNotNil(validator.validate(value: "06.07.2020 23:59:59" as Date))
        XCTAssertNotNil(validator.validate(value: "14.07.2020 00:00:01"as Date))
        XCTAssertEqual(validator.validate(value: "14.04.2020 00:00:01" as Date)?.code, .notBetweenDates)
    }

    func testInvalidArgumentReturnedIfBetweenDatesNotInRange() {
        validator.betweenDates("01.01.2020", "01.01.2000")
        XCTAssertEqual(validator.validate(value: "14.03.2020 15:43:16" as Date)?.code, .invalidArgument)
    }

    func testInvalidArgumentReturnedIfBetweenEqualDates() {
        validator.betweenDates("01.01.2000", "01.01.2000")
        XCTAssertEqual(validator.validate(value: "14.03.2020 15:43:16" as Date)?.code, .invalidArgument)
    }

    func testInvalidArgumentReturnedIfBetweenDatesNotIncludingNotInRange() {
        validator.betweenDatesNotIncluding("01.01.2020 00:00:01", "01.01.2000")
        XCTAssertEqual(validator.validate(value: "14.03.2020 15:43:16" as Date)?.code, .invalidArgument)
    }

    func testInvalidArgumentReturnedIfBetweenEqualDatesNotIncluding() {
        validator.betweenDatesNotIncluding("01.01.2000", "01.01.2000")
        XCTAssertEqual(validator.validate(value: "14.03.2020 15:43:16" as Date)?.code, .invalidArgument)
    }

    func testBetweenDatesWrongType() {
        validator.betweenDates("01.01.2020 00:00:01", "01.01.2000")
        XCTAssertEqual(validator.validate(value: 2), ValidationError(.wrongType))
    }

    func testBetweenDatesNotIncludingWrongType() {
        validator.betweenDatesNotIncluding("01.01.2020 00:00:01", "01.01.2000")
        XCTAssertEqual(validator.validate(value: 2), ValidationError(.wrongType))
    }

    // MARK: - Messages

    func testNoEarlierThenMessage() {
        let validator = makeDefaultValidator()
        validator.earlierThan("15.06.2034 09:00:00").notEarlierThenErrorMessage("not eariler then")
        let exact: Date = "15.06.2034 09:00:00"
        XCTAssertEqual(validator.validate(value: exact), ValidationError(.notEarlierThan, message: "not eariler then"))
    }

    func testNotEarlierOrEqualErrorMessage() {
        validator.earlierOrEqualTo("15.06.2034 09:00:00").notEarlierOrEqualToMessage("earlierOrEqualTo")
        let second: Date = "15.06.2034 09:00:01"
        XCTAssertEqual(validator.validate(value: second), ValidationError(.notEarlierThanOrEqualTo, message: "earlierOrEqualTo"))
    }

    func testNotLaterThenMessage() {
        validator.laterThan("21.07.2012 12:00:00").notLaterThanErrorMessage("laterThan")
        let exact: Date = "21.07.2012 12:00:00"
        XCTAssertEqual(validator.validate(value: exact), ValidationError(.notLaterThan, message: "laterThan"))
    }

    func testNotLaterOrEqualErrorMessage() {
        validator.laterOrEqualTo("21.07.2012 12:00:00").notLaterOrEqualToMessage("secondEarlier")
        let secondEarlier: Date = "21.07.2012 11:59:59"
        XCTAssertEqual(validator.validate(value: secondEarlier), ValidationError(.notLaterThanOrEqualTo, message: "secondEarlier"))
    }

    func testNotBetweenDatesErrorMessage() {
        validator.betweenDates("14.03.2020 15:43:10", "14.03.2020 15:43:15").notBetweenDatesMessage("betweenDates")
        XCTAssertEqual(validator.validate(value: "14.03.2020 15:43:09" as Date),
                       ValidationError(.notBetweenDates, message: "betweenDates"))
    }

    func testNotBetweenDatesNotIncludingErrorMessage() {
        validator.betweenDatesNotIncluding("07.07.2020", "14.07.2020").notBetweenDatesMessage("betweenDates")
        XCTAssertEqual(validator.validate(value: "07.07.2020 00:00:00" as Date),
                       ValidationError(.notBetweenDates, message: "betweenDates"))
    }

    // MARK: - TimeInterval

    func testEarlierThenTimeInterval_Success() {
        validator.earlierThan(1342872000)
        let secondEarlier: Date = "21.07.2012 11:59:59"
        XCTAssertNil(validator.validate(value: secondEarlier))
        let minuteEarlier: Date = "21.07.2012 11:59:00"
        XCTAssertNil(validator.validate(value: minuteEarlier))
        let hoursEarlier: Date = "21.07.2012 02:32:31"
        XCTAssertNil(validator.validate(value: hoursEarlier))
        let dayEarlier: Date = "20.07.2012"
        XCTAssertNil(validator.validate(value: dayEarlier))
        let weakEarlier: Date = "10.07.2012"
        XCTAssertNil(validator.validate(value: weakEarlier))
        let monthEarlier: Date = "21.06.2012"
        XCTAssertNil(validator.validate(value: monthEarlier))
        let halfYearEariler: Date = "01.01.2012"
        XCTAssertNil(validator.validate(value: halfYearEariler))
        let threeYaersEarlier: Date = "21.07.2009"
        XCTAssertNil(validator.validate(value: threeYaersEarlier))
        let manyYaersEarlier: Date = "13.02.222"
        XCTAssertNil(validator.validate(value: manyYaersEarlier))
    }

    func testEarlierThenTimeInterval_Fail() {
        validator.earlierThan(2033888400)
        let exact = TimeInterval(2033888400)
        XCTAssertNotNil(validator.validate(value: exact))
        XCTAssertEqual(validator.validate(value: exact)?.code, .notEarlierThan)
        let second: TimeInterval = 2033888401
        XCTAssertNotNil(validator.validate(value: second))
        let minute: TimeInterval = 2033888460
        XCTAssertNotNil(validator.validate(value: minute))
        let hours: TimeInterval = 2034026639
        XCTAssertNotNil(validator.validate(value: hours))
        let days: TimeInterval = 2034147600
        XCTAssertNotNil(validator.validate(value: days))
        let month: TimeInterval = 2041923600
        XCTAssertNotNil(validator.validate(value: month))
        let years: TimeInterval = 4463802000
        XCTAssertNotNil(validator.validate(value: years))
    }
}

