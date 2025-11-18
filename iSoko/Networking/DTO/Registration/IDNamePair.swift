//
//  IDNamePair.swift
//  
//
//  Created by Edwin Weru on 18/11/2025.
//

public struct IDNamePair<ID: Codable & Hashable>: Codable {
    public let id: ID
    public let name: String
}

// Explicit aliases
public typealias IDNamePairInt = IDNamePair<Int>       // For Int-based IDs
public typealias IDNamePairString = IDNamePair<String> // For String-based IDs

