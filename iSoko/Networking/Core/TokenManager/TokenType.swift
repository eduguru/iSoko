//
//  TokenType.swift
//  
//
//  Created by Edwin Weru on 29/01/2026.
//

public enum TokenType: Codable {
    case guest
    case loggedIn
    case vendor
    case other(String)

    // Custom decoding logic
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)

        switch value {
        case "guest": self = .guest
        case "logged_in": self = .loggedIn
        default: self = .other(value)
        }
    }

    // Custom encoding logic
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .guest: try container.encode("guest")
        case .loggedIn: try container.encode("logged_in")
        case .vendor: try container.encode("vendor")
        case .other(let value): try container.encode(value)
        }
    }
}
