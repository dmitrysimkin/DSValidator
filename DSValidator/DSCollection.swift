//
//  DSCollection.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/17/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

public protocol DSCollection {
    func includes(_ object: Any?) -> Bool
}
