//
//  ValueValidatorStringTests.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 3/14/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import XCTest
@testable import DSValidator

class ValueValidatorStringTests: XCTestCase {

    lazy var validator = makeDefaultValidator()

    struct CustomStruct { }
    class CustomClass { }
    let wrongTypeTestValues: [Any] = [2, Date(), Data(), CustomStruct(), CustomClass(), Double(321.32), Float(32.32)]

    // MARK: - Lenght from
    func testLengthFrom() {
        validator.length(from: 5)
        XCTAssertNil(validator.validateAll(value: "12345").first)
        XCTAssertNil(validator.validateAll(value: "666666").first)
        XCTAssertNil(validator.validateAll(value: "hszdhasdjksad").first)
        XCTAssertNil(validator.validateAll(value: "DJAHSDHJGADJA131261327878fda").first)
        XCTAssertEqual(validator.validateAll(value: "4444").first?.code, .lengthNotFrom)
        XCTAssertEqual(validator.validateAll(value: "333").first?.code, .lengthNotFrom)
        XCTAssertEqual(validator.validateAll(value: "22").first?.code, .lengthNotFrom)
        XCTAssertEqual(validator.validateAll(value: "a").first?.code, .lengthNotFrom)
        XCTAssertEqual(validator.validateAll(value: "").first?.code, .lengthNotFrom)
        XCTAssertNil(validator.validateAll(value: nil).first)

        validator = makeDefaultValidator()
        validator.length(from: 0)
        XCTAssertNil(validator.validate(value: ""))
        XCTAssertNil(validator.validate(value: "😀"))
        XCTAssertNil(validator.validate(value: "\u{24}\u{2665}\u{1F496}"))
    }

    func testLenghtFromWrongType() {
        validator.length(from: 4)
        for value in wrongTypeTestValues {
            XCTAssertEqual(validator.validate(value: value)?.code, .wrongType, "Value \(value) should not fit by type")
        }
    }

    // MARK: - Lenght Up To
    func testLengthUpTo() {
        validator.length(upTo: 3)
        XCTAssertNil(validator.validate(value: ""))
        XCTAssertNil(validator.validate(value: "😀"))
        XCTAssertNil(validator.validate(value: "😀\u{24}"))
        XCTAssertNil(validator.validate(value: "323"))
        XCTAssertEqual(validator.validate(value: "gggg")?.code, .lengthNotUpTo)

        validator = makeDefaultValidator()
        validator.length(upTo: 0)
        XCTAssertNil(validator.validate(value: ""))
        XCTAssertEqual(validator.validate(value: "0")?.code, .lengthNotUpTo)
    }

    func testLengthUpToWrongType() {
        validator.length(upTo: 5)
        for value in wrongTypeTestValues {
            XCTAssertEqual(validator.validate(value: value)?.code, .wrongType, "Value \(value) should not fit by type")
        }
    }

    // MARK: - Lenght exact
    func testLenghtExact() {
        validator = makeDefaultValidator()
        validator.length(exact: 0)
        XCTAssertNil(validator.validate(value: ""))
        XCTAssertEqual(validator.validate(value: "😀")?.code, .lengthNotExact)
        XCTAssertEqual(validator.validate(value: "😀\u{24}")?.code, .lengthNotExact)
        XCTAssertEqual(validator.validate(value: "HDAHLSGDASDKJzncqwuehashd")?.code, .lengthNotExact)

        validator = makeDefaultValidator()
        validator.length(exact: 1)
        XCTAssertEqual(validator.validate(value: "")?.code, .lengthNotExact)
        XCTAssertNil(validator.validate(value: "F"))
        XCTAssertNil(validator.validate(value: "D"))
        XCTAssertNil(validator.validate(value: "1"))
        XCTAssertEqual(validator.validate(value: "HDAHLSGDASDKJzncqwuehashd")?.code, .lengthNotExact)

        validator = makeDefaultValidator()
        validator.length(exact: 10)
        XCTAssertEqual(validator.validate(value: "")?.code, .lengthNotExact)
        XCTAssertNil(validator.validate(value: "1234567890"))
        XCTAssertNil(validator.validate(value: "1010101010"))
        XCTAssertNil(validator.validate(value: "DASDADSD😀\u{24}"))
        XCTAssertEqual(validator.validate(value: "123456789")?.code, .lengthNotExact)
        XCTAssertEqual(validator.validate(value: "12345678901")?.code, .lengthNotExact)
    }

    func testLengthExactWrongType() {
        validator.length(exact: 3)
        for value in wrongTypeTestValues {
            XCTAssertEqual(validator.validate(value: value)?.code, .wrongType, "Value \(value) should not fit by type")
        }
    }

    // MARK: - Lenght from and to
    func testLengthFromTo() {
        validator.length(from: 0, to: 2)
        XCTAssertNil(validator.validate(value: ""))
        XCTAssertNil(validator.validate(value: "2"))
        XCTAssertNil(validator.validate(value: "33"))
        XCTAssertEqual(validator.validate(value: "332")?.code, .lengthNotFromTo)


        validator = makeDefaultValidator()
        validator.length(from: 1, to: 4)
        XCTAssertNil(validator.validate(value: "-"))
        XCTAssertNil(validator.validate(value: "!!"))
        XCTAssertNil(validator.validate(value: "±±±"))
        XCTAssertNil(validator.validate(value: "////"))
        XCTAssertEqual(validator.validate(value: "")?.code, .lengthNotFromTo)
        XCTAssertEqual(validator.validate(value: "55555")?.code, .lengthNotFromTo)
        XCTAssertEqual(validator.validate(value: "666666")?.code, .lengthNotFromTo)

        validator = makeDefaultValidator()
        validator.length(from: 5, to: 5)
        XCTAssertNil(validator.validate(value: "////?"))
        XCTAssertEqual(validator.validate(value: "4444")?.code, .lengthNotFromTo)
        XCTAssertEqual(validator.validate(value: "666666")?.code, .lengthNotFromTo)
    }

    func testLengthFromToReturnsInvalidArgument() {
        validator.length(from: 6, to: 5)
        XCTAssertEqual(validator.validate(value: "#@#@")?.code, .invalidArgument)

        validator = makeDefaultValidator()
        validator.length(from: 100, to: 0)
        XCTAssertEqual(validator.validate(value: "")?.code, .invalidArgument)
        let longString = "akldjashfsdjkfhajslkdfhsdajkfhsadjfhsjlfdhasldkfhasklfjsadfsladfsaldf"
        XCTAssertEqual(validator.validate(value: longString)?.code, .invalidArgument)
    }

    func testLengthFromToWrongType() {
        validator.length(from: 3, to: 7)
        for value in wrongTypeTestValues {
            XCTAssertEqual(validator.validate(value: value)?.code, .wrongType, "Value \(value) should not fit by type")
        }
    }

    // MARK: - Match
    func testMatch() {
        validator.match("1")
        XCTAssertEqual(validator.validate(value: "2"), ValidationError(.notMatch))
        XCTAssertEqual(validator.validate(value: "3123ad"), ValidationError(.notMatch))
        XCTAssertNil(validator.validate(value: "1"))

        validator = makeDefaultValidator()
        validator.match("\u{24}")
        XCTAssertEqual(validator.validate(value: "\u{23}"), ValidationError(.notMatch))
        XCTAssertEqual(validator.validate(value: "\u{25}"), ValidationError(.notMatch))
        XCTAssertEqual(validator.validate(value: "3123ad"), ValidationError(.notMatch))
        XCTAssertNil(validator.validate(value: "\u{24}"))

        validator = makeDefaultValidator()
        validator.match("Test String")
        XCTAssertEqual(validator.validate(value: "Test"), ValidationError(.notMatch))
        XCTAssertEqual(validator.validate(value: "String"), ValidationError(.notMatch))
        XCTAssertEqual(validator.validate(value: "Test Str"), ValidationError(.notMatch))
        XCTAssertEqual(validator.validate(value: "Test String "), ValidationError(.notMatch))
        XCTAssertEqual(validator.validate(value: " "), ValidationError(.notMatch))
        XCTAssertNil(validator.validate(value: "Test String"))
    }

    func testMatchWrongType() {
        validator.match(" ")
        for value in wrongTypeTestValues {
            XCTAssertEqual(validator.validate(value: value)?.code, .wrongType, "Value \(value) should not fit by type")
        }
    }

    // MARK: - Differ
    func testDiffer() {
        validator.differ("Test String")
        XCTAssertEqual(validator.validate(value: "Test String"), ValidationError(.notDiffer))
        XCTAssertNil(validator.validate(value: "Test String "))
        XCTAssertNil(validator.validate(value: "Test Strin"))
        XCTAssertNil(validator.validate(value: "Test"))
        XCTAssertNil(validator.validate(value: "Test Str"))
        XCTAssertNil(validator.validate(value: "String"))
        XCTAssertNil(validator.validate(value: "test"))
        XCTAssertNil(validator.validate(value: "string"))
    }

    func testDifferWrongType() {
        validator.differ(" ")
        for value in wrongTypeTestValues {
            XCTAssertEqual(validator.validate(value: value)?.code, .wrongType, "Value \(value) should not fit by type")
        }
    }

    func testDecimal() {
        validator.decimal()
        XCTAssertEqual(validator.validate(value: "111bla"), ValidationError(.notDecimal))
        XCTAssertEqual(validator.validate(value: "string"), ValidationError(.notDecimal))
        XCTAssertEqual(validator.validate(value: "."), ValidationError(.notDecimal))
        XCTAssertEqual(validator.validate(value: "-"), ValidationError(.notDecimal))
        XCTAssertEqual(validator.validate(value: "1."), ValidationError(.notDecimal))
        XCTAssertEqual(validator.validate(value: 32), ValidationError(.wrongType))

        XCTAssertNil(validator.validate(value: "120"))
        XCTAssertNil(validator.validate(value: "120.099"))
        XCTAssertNil(validator.validate(value: "120,00"))
        XCTAssertNil(validator.validate(value: "-3"))
        XCTAssertNil(validator.validate(value: ".3323"))
        XCTAssertNil(validator.validate(value: "0.5"))
        XCTAssertNil(validator.validate(value: "-0.000000009"))
        XCTAssertNil(validator.validate(value: "0"))
        XCTAssertNil(validator.validate(value: "312312312412121332"))
    }

    // MARK: - Messages
    func testLengthFromErrorMessage() {
        validator.length(from: 5).lengthNotFromMessage("lengthFrom")
        XCTAssertEqual(validator.validateAll(value: "4444").first, ValidationError(.lengthNotFrom, message: "lengthFrom"))
    }

    func testLengthUpToErrorMessage() {
        validator.length(upTo: 4).lengthNotUpToMessage("lengthUpTo")
        XCTAssertEqual(validator.validate(value: "1321312"),
                       ValidationError(.lengthNotUpTo, message: "lengthUpTo"))
    }

    func testLengthExactErrorMessage() {
        validator.length(exact: 1).lengthNoExactMessage("lengthExact")
        XCTAssertEqual(validator.validate(value: ""), ValidationError(.lengthNotExact, message: "lengthExact"))
    }

    func testLenghtFromAndToErrorMessage() {
        validator.length(from: 5, to: 5).lengthNotFromToMessage("lengthFromTo")
        XCTAssertEqual(validator.validate(value: "4444"),
                       ValidationError(.lengthNotFromTo, message: "lengthFromTo"))
    }

    func testMatchErrorMessage() {
        validator.match("1").notMatchMessage("match")
        XCTAssertEqual(validator.validate(value: "2"),
                       ValidationError(.notMatch, message: "match"))
    }

    func testDifferErrorMessage() {
        validator.differ("Test String").notDifferMessage("differ")
        XCTAssertEqual(validator.validate(value: "Test String"),
                       ValidationError(.notDiffer, message: "differ"))
    }

    func testNotDecimalMessage() {
        validator.decimal().notDecimalMessage("Decimal")
        XCTAssertEqual(validator.validate(value: "Test String"),
                       ValidationError(.notDecimal, message: "Decimal"))
    }

    func testHasEmoji() {
        validator.hasEmoji()
        XCTAssertNil(validator.validate(value: "😁😂🇲🇿"))
        XCTAssertNil(validator.validate(value: "fruit🍎"))
        XCTAssertNil(validator.validate(value: "WOW💥"))
        XCTAssertNil(validator.validate(value: "⚓"))
        XCTAssertNil(validator.validate(value: "0️⃣"))
        XCTAssertNil(validator.validate(value: "1️⃣"))
        XCTAssertNil(validator.validate(value: "🔟"))
        XCTAssertNil(validator.validate(value: "0️⃣1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣🔟"))
        XCTAssertEqual(validator.validate(value: ""), ValidationError(.noEmoji))
        XCTAssertEqual(validator.validate(value: "no emojis"), ValidationError(.noEmoji))
        XCTAssertEqual(validator.validate(value: "1234"), ValidationError(.noEmoji))
        XCTAssertEqual(validator.validate(value: "-!?±..vxm"), ValidationError(.noEmoji))
    }

    func testHasNoEmoji() {
        validator.hasNoEmoji()
        XCTAssertNil(validator.validate(value: nil))
        XCTAssertNil(validator.validate(value: ""))
        XCTAssertNil(validator.validate(value: "no emojis"))
        XCTAssertNil(validator.validate(value: "1234"))
        XCTAssertNil(validator.validate(value: "-!?±..vxm"))
        XCTAssertEqual(validator.validate(value: "😁😂🇲🇿"), ValidationError(.hasEmoji))
        XCTAssertEqual(validator.validate(value: "fruit🍎"), ValidationError(.hasEmoji))
        XCTAssertEqual(validator.validate(value: "WOW💥"), ValidationError(.hasEmoji))
        XCTAssertEqual(validator.validate(value: "⚓"), ValidationError(.hasEmoji))
        XCTAssertEqual(validator.validate(value: "0️⃣"), ValidationError(.hasEmoji))
        XCTAssertEqual(validator.validate(value: "0️⃣1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣🔟"), ValidationError(.hasEmoji))
    }

    func testHasEmojiPerformance() {
        measure {
            validator.hasEmoji()
            XCTAssertNil(validator.validate(value: "🧰🧲🧪🧫🧬🧴🧷🧹🧺"))
        }
    }

    func testCustomHasEmojiMessage() {
        validator.hasEmoji().noEmojiMessage("Has NO Emoji")
        XCTAssertEqual(validator.validate(value: "Test String"),
                       ValidationError(.noEmoji, message: "Has NO Emoji"))
    }

    func testCustomHasNoEmojiMessage() {
        validator.hasNoEmoji().hasEmojiMessage("Has Emoji")
        XCTAssertEqual(validator.validate(value: "🟠da"),
                       ValidationError(.hasEmoji, message: "Has Emoji"))
    }
}

