//
//  AnyCodableValue.swift
//  
//
//  Created by Edwin Weru on 18/05/2026.
//

import Foundation

public enum AnyCodableValue: Equatable, Hashable, CustomStringConvertible {
    case int(Int)
    case double(Double)
    case bool(Bool)
    case string(String)
    case array([AnyCodable])
    case dictionary([String: AnyCodable])
    case null

    public var description: String {
        switch self {
        case .int(let v): return "\(v)"
        case .double(let v): return "\(v)"
        case .bool(let v): return "\(v)"
        case .string(let v): return "\"\(v)\""
        case .array(let v): return "[\(v.map(\.description).joined(separator: ", "))]"
        case .dictionary(let v): return "{\(v.map { "\($0): \($1)" }.joined(separator: ", "))}"
        case .null: return "null"
        }
    }

    public var rawValue: Any {
        switch self {
        case .int(let v): return v
        case .double(let v): return v
        case .bool(let v): return v
        case .string(let v): return v
        case .array(let v): return v.map { $0.value }
        case .dictionary(let v): return v.mapValues { $0.value }
        case .null: return NSNull()
        }
    }
}
