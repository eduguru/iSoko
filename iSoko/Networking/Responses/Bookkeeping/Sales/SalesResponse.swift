//
//  SalesResponse.swift
//
//
//  Created by Edwin Weru on 25/03/2026.
//

import Foundation

public struct SalesResponse: Codable {
    public let id: Int
    
    public let type: IDNamePairInt?
    public let customer: IDNamePairInt?
    public let totalAmount: Double?
    public let paymentMethod: IDNamePairInt?
    
    public let saleDate: String?
    
    public let description: String?
    public let items: [SalesItemResponse]?
    
    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case customer
        case totalAmount
        case paymentMethod
        case description
        case items
        
        case datetimeCreated
        case saleDateAlt = "sale_date"
    }
    
    // MARK: - Decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        type = try container.decodeIfPresent(IDNamePairInt.self, forKey: .type)
        customer = try container.decodeIfPresent(IDNamePairInt.self, forKey: .customer)
        totalAmount = try container.decodeIfPresent(Double.self, forKey: .totalAmount)
        paymentMethod = try container.decodeIfPresent(IDNamePairInt.self, forKey: .paymentMethod)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        items = try container.decode([SalesItemResponse].self, forKey: .items)
        
        saleDate =
            try container.decodeIfPresent(String.self, forKey: .datetimeCreated)
            ?? container.decodeIfPresent(String.self, forKey: .saleDateAlt)
    }
    
    // MARK: - Encoder
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(customer, forKey: .customer)
        try container.encodeIfPresent(totalAmount, forKey: .totalAmount)
        try container.encodeIfPresent(paymentMethod, forKey: .paymentMethod)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(items, forKey: .items)
        
        // Choose ONE key when encoding (important)
        try container.encodeIfPresent(saleDate, forKey: .datetimeCreated)
    }
}

public struct SalesItemResponse: Codable {
    public let id: Int
    public let product: IDNamePairInt?
    public let quantity: Double?
    public let unitPrice: Double?
    public let totalPrice: Double?
}
