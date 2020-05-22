//
//  Syntax.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/17/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

/// String syntax validation enum
public enum DSSyntax {
    /// Email
    case email
    /// Person's first name
    case name
    /// HTTP url
    case http
    /// File ulr
    case file
    /// Webscket url
    case webSocket
    /// IP v4 address
    case IPv4
    /// IP v6 address
    case IPv6
    /// Domain name
    case domain
    /// Geographic coordinates
    case geoCoordinate
}
