//
//  MockValidationError.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 2/23/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

struct MockValidationError: Error {
    var localizedDescription: String
    
    init(localizedDescription: String) {
        self.localizedDescription = localizedDescription
    }
}

extension MockValidationError: LocalizedError {
    public var errorDescription: String? {
        return self.localizedDescription
    }
}
