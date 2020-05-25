//
//  TestModel.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/24/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

struct UserCredentialsInput {
    let username: String?
    let password: String?
    let confirmPassword: String?
}

class TestClass {
    let age: Int
    let date: Date
    let optionalDate: Date?

    init(age: Int, date: Date, optionalDate: Date? = nil) {
        self.age = age
        self.date = date
        self.optionalDate = optionalDate
    }
}

enum TestEnum {
    case one
    case two
}

enum TestEnumWithRawValue: Int {
    case ten = 10
    case thousand = 100
}

enum TestEnumWithAssosiatedValue {
    case range(Int, Int)
    case lable(String)
}

protocol TestProtocol {
    var amount: Double { get }
    var bonus: Double? { get set }
}

struct TestStructConformingProtocol: TestProtocol {
    var amount: Double
    var bonus: Double?
}

class TestClassConformingProtocol: TestProtocol {
    var amount: Double
    var bonus: Double?
    init(amount: Double, bonus: Double?) {
        self.amount = amount
        self.bonus = bonus
    }
}

class TestSubClassA: TestClass {
    let amount: Double
    init(age: Int, date: Date, optionalDate: Date? = nil, amount: Double) {
        self.amount = amount
        super.init(age: age, date: date, optionalDate: optionalDate)
    }
}

class TestSubClassB: TestSubClassA {
    var bonus: Double?

    init(age: Int, date: Date, optionalDate: Date? = nil, amount: Double, bonus: Double? = nil) {
        self.bonus = bonus
        super.init(age: age, date: date, optionalDate: optionalDate, amount: amount)
    }
}

struct TestStructWithComputedProperty {
    let stored: String?
    var computed: Int? { 10 }
}
