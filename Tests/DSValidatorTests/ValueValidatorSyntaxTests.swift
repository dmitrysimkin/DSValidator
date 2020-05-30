//
//  ValueValidatorSyntaxTests.swift
//  DSValidatorTests
//
//  Created by Dzmitry Simkin on 4/26/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import XCTest
@testable import DSValidator

class ValueValidatorSyntaxTests: XCTestCase {

    let validator = DSValueValidator(property: DefaultValueValidatorName)

    // MARK: - Email
    func testValidEmails() {
        validator.syntax(.email)

        let emails: [String] = [
            "d@d.cc",
            "ds%@das.co",
            "ds.ds.ds.ds.ds@host.com",
            "_%+-@das.com",
            "das/das@das.co",
            "email@example.com",
            "firstname.lastname@example.com",
            "email@subdomain.example.com",
            "firstname+lastname@example.com",
            "1234567890@example.com",
            "email@example-one.com",
            "_______@example.com",
            "email@example.name",
            "email@example.museum",
            "email@example.co.jp",
            "firstname-lastname@example.com",

            //            "\"email\"@example.com",
            //            "email@123.123.123.123",
            //            "email@[123.123.123.123]",

        ]
        emails.forEach { (email) in
            XCTAssertNil(validator.validate(value: email), "\(email) should be a valid email)")
        }
    }

    func testNotValidEmails() {
        validator.syntax(.email)
        let emails: [String] = [
            "@ds.cmo",
            "das/!#$ˆ&*(das@das.co",
            "dasd@dads\\\\.com",
            "ds.@das.co",

            "plainaddress",
            "#@%^%#$@#$@#.com",
            "@example.com",
            "Joe Smith <email@example.com>",
            "email.example.com",
            "email@example@example.com",
            ".email@example.com",
            "email.@example.com",
            "email..email@example.com",
            "あいうえお@example.com",
            "email@example.com (Joe Smith)",
            "email@example",
            "email@-example.com",
            "email@example..com",
            "Abc..123@example.com",
            "\"(),:;<>[\\]@example.com",
            "just\"not\"right@example.com",
            "this\\ is\\\"really\\\"not\\\\allowed@example.com"


            //            "email@111.222.333.44444",

        ]
        emails.forEach { (email) in
            XCTAssertEqual(validator.validate(value: email)?.code, .notEmail, "\(email) is should be invalid email")
        }
    }

    // MARK: - name
    func testNameIsValid() {
        validator.syntax(.name)

        let values: [String] = [
            "John",
            "MJ",
            "Kimberley-Whatsoever",
            "d'Artagnan",
            "Ki Ju",
            "Max Jr.",
            "DASDFASD",
        ]
        values.forEach { (value) in
            XCTAssertNil(validator.validate(value: value), "\(value) should be a valid name)")
        }
    }

    func testNameIsNotValid() {
        validator.syntax(.name)

        let values: [String] = [
            "$das",
            "12312",
            "fsd@asd",
            "NDASDS)",
            "Ki_Ju",
            ""
        ]
        values.forEach { (value) in
            XCTAssertEqual(validator.validate(value: value)?.code, .notName, "\(value) should be a invalid name)")
        }
    }

    // MARK:- HTTP
    func testValidHTTP() {
        validator.syntax(.http)

        let values: [String] = [
            "http://www.google.com",
            "http://www.google.com/",
            "https://www.google.com",
            "http://google.second.com",
            "https://EXAMPLE.second.com",
            "https://example.second.com/dada/das/dasd.txt",
            "google.com",
            "google.com/",
            "dsada.dasd.das/asdad?dasd=ds",
            "http://142.42.1.1:8080/",
            "255.255.255.255:8080",
            "255.255.255.333",
            "http://142.42.1.1/",
            "http://223.255.255.254",
            "http://1337.net"
        ]
        values.forEach { (value) in
            XCTAssertNil(validator.validate(value: value), "\(value) should be a valid http url)")
        }
    }

    func testNotValidHTTP() {
        validator.syntax(.http)

        let values: [String] = [
            "ws://www.google.com",
            "wss:/www.google.com",
            "http:/google.second.com",
            "htpps://example.second.com",
            "das.(",
            "file://example.second.com",
            "example..com",
            ".example.com",
            "ex ample.com",
            "255.255.255.255:8080832"
        ]
        values.forEach { (value) in
            XCTAssertEqual(validator.validate(value: value)?.code, .notHTTP, "\(value) should be a invalid http url)")
        }
    }

    func testFileIsValid() {
        validator.syntax(.file)

        let values: [String] = [
            "file://www.google.com/dasd/adasd.jpeg",
            "file://ddds.com/DSD-deqw_d%/da_d%-sd/adasd.jpeg",
            "file://google.com",
            "file://www.google.second.com",
        ]
        values.forEach { (value) in
            XCTAssertNil(validator.validate(value: value), "\(value) should be a valid http url)")
        }
    }

    func testFileIsNotValid() {
        validator.syntax(.file)

        let values: [String] = [
            "file://www.google.com//dasd/adasd.jpeg",
            "google.com",
            "file://www.google.second.com?dasd=dsad&dasdas=23",
            "file://google.second.com?dasd=dsad&dasdas=23",
        ]
        values.forEach { (value) in
            XCTAssertEqual(validator.validate(value: value)?.code, .notFile, "\(value) should be a invalid file url)")
        }
    }

    // MARK:- Web socket

    func testWebSocketIsValid() {
        validator.syntax(.webSocket)

        let values: [String] = [
            "ws://www.google.com",
            "wss://www.google.com:323/312dasd/dasd?das=ads",
        ]
        values.forEach { (value) in
            XCTAssertNil(validator.validate(value: value), "\(value) should be a valid WS url")
        }
    }

    func testWebSocketIsNotValid() {
        validator.syntax(.webSocket)

        let values: [String] = [
            "file://www.google.com//dasd/adasd.jpeg",
            "google.com",
        ]
        values.forEach { (value) in
            XCTAssertEqual(validator.validate(value: value)?.code, .notWebSocket, "\(value) should be a invalid WS url")
        }
    }

    // MARK: - IPv4

    func testValidIPv4() {
        validator.syntax(.IPv4)

        let values: [String] = [
            "0.0.0.0",
            "255.255.255.0",
            "255.255.255.10",
            "255.255.255.90",
            "255.255.255.99",
            "255.255.255.100",
            "255.255.255.150",
            "255.255.255.199",
            "255.255.255.200",
            "255.255.255.210",
            "255.255.255.255",

            "192.168.0.1",
            "127.0.0.1",
            "90.92.3.132",
            "1.1.1.1",
        ]
        values.forEach { (value) in
            XCTAssertNil(validator.validate(value: value), "\(value) should be a valid IPv4 address")
        }
    }

    func testNotValidIPv4() {
         validator.syntax(.IPv4)

         let values: [String] = [
             "10.10.10",
             "10.10",
             "10",
             "a.a.a.a",
             "10.0.0.a",
             "10.10.10.256",
             "256.10.10.255",
             "222.222.2.999",
             "999.10.10.20",
             "2222.22.22.22",
             "22.2222.22.2"
         ]
         values.forEach { (value) in
            XCTAssertEqual(validator.validate(value: value)?.code, .notIPv4, "\(value) should be a not valid IPv4 address")
         }
     }

    //MARK: - IPv6

    func testValidIPv6() {
        validator.syntax(.IPv6)

        let values: [String] = [
            "2001:0:0:0:DB8:800:200C:417A",
            "2001::DB8:800:200C:417A",
            "FF01:0:0:0:0:0:0:101",
            "FF01::101",
            "0:0:0:0:0:0:0:1",
            "::1",
            "0:0:0:0:0:0:0:0",
            "::",
            "2001:DB8:3000:4000:5000:6000:7000:8001",
        ]
        values.forEach { (value) in
            XCTAssertNil(validator.validate(value: value), "\(value) should be a valid IPv6 address")
        }
    }

    func testNotValidIPv6() {
         validator.syntax(.IPv6)

         let values: [String] = [
            "2001:DB8:3000:4000:5000:6000:7000:8001:3232",
            "::G",
         ]
         values.forEach { (value) in
            XCTAssertEqual(validator.validate(value: value)?.code, .notIPv6, "\(value) should be a not valid IPv6 address")
         }
     }

    // MARK: - Regular expression

    func testMatchToCustomRegexp() {
        let testCases: [(pattern: String, options: NSRegularExpression.Options, value: String)] = [
            ("match", [], "match"),
            ("\\d{3}", [], "142"),
            ("https?", [], "http"),
            ("https?", [], "https"),
            ("[a-z]", [.caseInsensitive], "HTTP"),
        ]
        testCases.forEach { (testCase) in
            let (pattern, options, value) = testCase
            let validator = DSValueValidator(property: DefaultValueValidatorName)
            validator.regex(pattern, options: options)
            XCTAssertNil(validator.validate(value: value), "\(value) should match to regexp: \(pattern)")
        }
    }

    func testDoesNotMatchToCustomRegexp() {
        let testCases: [(pattern: String, options: NSRegularExpression.Options, value: String)] = [
            ("match", [], "matTch"),
            ("[0-9]{2,5}", [], "1"),
            ("[a-z]", [], "HTTP"),
            ("\\w", [], "±"),
            ("[a-zat", [], ""),
        ]
        testCases.forEach { (testCase) in
            let (pattern, options, value) = testCase
            let validator = DSValueValidator(property: DefaultValueValidatorName)
            validator.regex(pattern, options: options)
            XCTAssertEqual(validator.validate(value: value)?.code, .notMatchToRegexp, "\(value) should not match to regexp: \(pattern)")
        }
    }

    // MARK: - Domain

    func testValidDomainNames() {
        validator.syntax(.domain)

        let values: [String] = [
            "stack.com",
            "sta-ck.com",
            "sta---ck.com",
            "9sta--ck.com",
            "sta--ck9.com",
            "stack99.com",
            "99stack.com",
            "sta99ck.com",
            "google.com.uk",
            "google.co.in",
            "google.com",
            "maselkowski.pl",
            "m.maselkowski.pl",
            "xn--masekowski-d0b.pl",
            "xn--fiqa61au8b7zsevnm8ak20mc4a87e.xn--fiqs8s",
            "xn--stackoverflow.com",
            "stackoverflow.xn--com",
            "stackoverflow.co.uk",
            "xn--stackoverflow.com",
            "stackoverflow.xn--com",
            "stackoverFlow.co.uk"
        ]
        values.forEach { (value) in
            XCTAssertNil(validator.validate(value: value), "\(value) should be a valid domain name")
        }
    }

    func testNotValidDomainNames() {
         validator.syntax(.domain)

         let values: [String] = [
            "das",
            ".cod.ds",
            "cod.ds.dsd.",
            "asdsdcod.ds-",
            "mkyong.t.t.c",
            "mkyong,com",
            "kyong.com/users",
            "mkyong-.com",
            "sub.-mkyong.com",
        ]
         values.forEach { (value) in
            XCTAssertEqual(validator.validate(value: value)?.code, .notDomain, "\(value) should be a not valid domain name")
         }
     }

    // MARK: - Geo Coordinate

    func testValidGeoCoord() {
        validator.syntax(.geoCoordinate)

        let values: [String] = [
            "+90.0, -127.554334",
            "45, 180",
            "-90, -180",
            "-90.000, -180.0000",
            "+90, +180",
            "47.1231231, 179.99999999",
        ]
        values.forEach { (value) in
            XCTAssertNil(validator.validate(value: value), "\(value) should be a valid geo coordinat")
        }
    }

    func testNotValidGeoCoordinate() {
        validator.syntax(.geoCoordinate)

        let values: [String] = [
           "-90., -180.",
           "+90.1, -100.111",
           "-91, 123.456",
            "045, 180"
        ]
        values.forEach { (value) in
           XCTAssertEqual(validator.validate(value: value)?.code, .notGeoCoordinate, "\(value) should be a not valid geo coordinate")
        }
    }

    // MARK: - Other

    func testNotStringReturnsWrongType() {
        validator.syntax(.geoCoordinate)
        XCTAssertEqual(validator.validate(value: 3.33)?.code, .wrongType)
        XCTAssertEqual(validator.validate(value: Date())?.code, .wrongType)
    }

    // MARK: - Messages

    func testCustomErrorMessageForSyntax() {
        var validator: ValueValidator
        validator = makeDefaultValidator().fail(.notEmail).wrongSyntaxErrorMessage(.email, message: "Email")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notEmail, message: "Email"))
        validator = makeDefaultValidator().fail(.notName).wrongSyntaxErrorMessage(.name, message: "name")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notName, message: "name"))

        validator = makeDefaultValidator().fail(.notHTTP).wrongSyntaxErrorMessage(.http, message: "HTTP")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notHTTP, message: "HTTP"))

        validator = makeDefaultValidator().fail(.notFile).wrongSyntaxErrorMessage(.file, message: "File")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notFile, message: "File"))

        validator = makeDefaultValidator().fail(.notWebSocket).wrongSyntaxErrorMessage(.webSocket, message: "WS")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notWebSocket, message: "WS"))

        validator = makeDefaultValidator().fail(.notIPv4).wrongSyntaxErrorMessage(.IPv4, message: "IP4")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notIPv4, message: "IP4"))

        validator = makeDefaultValidator().fail(.notIPv6).wrongSyntaxErrorMessage(.IPv6, message: "IP6")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notIPv6, message: "IP6"))

        validator = makeDefaultValidator().fail(.notDomain).wrongSyntaxErrorMessage(.domain, message: "Domain")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notDomain, message: "Domain"))

        validator = makeDefaultValidator().fail(.notGeoCoordinate).wrongSyntaxErrorMessage(.geoCoordinate, message: "GEO")
        XCTAssertEqual(validator.validate(value: "", scenario: nil), ValidationError(.notGeoCoordinate, message: "GEO"))
    }

    func testCustomErrorMessageForRegexp() {
        validator.fail(.notMatchToRegexp).wrongRegexpErrorMessage("Regexp")
        XCTAssertEqual(validator.validate(value: ""), ValidationError(.notMatchToRegexp, message: "Regexp"))
    }
}
