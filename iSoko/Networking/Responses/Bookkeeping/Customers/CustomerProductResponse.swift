//
//  CustomerProductResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct CustomerProductResponse: Codable {
    public let id: Int
    public let name: String?
    public let price: Double?
    public let qty: Int?
    public let description: String?
}
