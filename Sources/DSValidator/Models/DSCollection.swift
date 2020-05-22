//
//  DSCollection.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/17/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

/// Protocol to simplify colletions validation interface
/// by wrapping up Array and Set
public protocol DSCollection {
    func includes(_ object: Any?) -> Bool
}
