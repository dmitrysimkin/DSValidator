//
//  Syntax+Extensions.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/17/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

extension Syntax {
    func code() -> ValidationError.Code {
        switch self {
        case .email: return .notEmail
        case .name: return .notName
        case .http: return .notHTTP
        case .file: return .notFile
        case .webSocket: return .notWebSocket
        case .IPv4: return .notIPv4
        case .IPv6: return .notIPv6
        case .domain: return .notDomain
        case .geoCoordinate: return .notGeoCoordinate
        }
    }
}
