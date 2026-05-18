//
//  AnyCodable.swift
//  
//
//  Created by Edwin Weru on 18/05/2026.
//

import Foundation

public struct AnyCodable: Codable, Equatable, Hashable, CustomStringConvertible {
    public let value: AnyCodableValue

    public var description: String {
        return value.description
    }

    // Init from Any type
    public init(_ value: Any) {
        switch value {
        case let v as Int:
            self.value = .int(v)
        case let v as Double:
            self.value = .double(v)
        case let v as Bool:
            self.value = .bool(v)
        case let v as String:
            self.value = .string(v)
        case let v as [Any]:
            self.value = .array(v.map { AnyCodable($0) })
        case let v as [String: Any]:
            self.value = .dictionary(v.mapValues { AnyCodable($0) })
        case is NSNull:
            self.value = .null
        default:
            self.value = .null
        }
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let v = try? container.decode(Int.self) {
            value = .int(v)
        } else if let v = try? container.decode(Double.self) {
            value = .double(v)
        } else if let v = try? container.decode(Bool.self) {
            value = .bool(v)
        } else if let v = try? container.decode(String.self) {
            value = .string(v)
        } else if let v = try? container.decode([AnyCodable].self) {
            value = .array(v)
        } else if let v = try? container.decode([String: AnyCodable].self) {
            value = .dictionary(v)
        } else if container.decodeNil() {
            value = .null
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported value")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case .int(let v): try container.encode(v)
        case .double(let v): try container.encode(v)
        case .bool(let v): try container.encode(v)
        case .string(let v): try container.encode(v)
        case .array(let v): try container.encode(v)
        case .dictionary(let v): try container.encode(v)
        case .null: try container.encodeNil()
        }
    }
}

// MARK: - AnyCodable Extensions

extension AnyCodable {
    public var asString: String? {
        if case .string(let str) = value {
            return str
        }
        return nil
    }

    public var asInt: Int? {
        if case .int(let i) = value {
            return i
        }
        return nil
    }

    public var asDouble: Double? {
        if case .double(let d) = value {
            return d
        }
        return nil
    }

    public var asBool: Bool? {
        if case .bool(let b) = value {
            return b
        }
        return nil
    }

    public var asArray: [AnyCodable]? {
        if case .array(let arr) = value {
            return arr
        }
        return nil
    }

    public var asDictionary: [String: AnyCodable]? {
        if case .dictionary(let dict) = value {
            return dict
        }
        return nil
    }

    public var raw: Any {
        return value.rawValue
    }
}

// MARK: - Dictionary Extensions
extension Dictionary where Key == String, Value == AnyCodable {
    public func string(for key: String) -> String? {
        return self[key]?.asString
    }
    
    public func int(for key: String) -> Int? {
        return self[key]?.asInt
    }
}

//// MARK: - Example Usage
//
//let dictionary: [String: AnyCodable] = [
//    "name": AnyCodable("John"),
//    "age": AnyCodable(25),
//    "active": AnyCodable(true),
//    "scores": AnyCodable([100, 90, 85]),
//    "address": AnyCodable(["city": "New York", "state": "NY"])
//]
//
//// Accessing values using type-safe methods
//if let name = dictionary.string(for: "name") {
//    print("Name: \(name)")  // Output: Name: John
//}
//
//if let age = dictionary.int(for: "age") {
//    print("Age: \(age)")  // Output: Age: 25
//}
//
//if let address = dictionary.dictionary(for: "address") {
//    if let city = address.string(for: "city") {
//        print("City: \(city)")  // Output: City: New York
//    }
//}
//
