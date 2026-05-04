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
    
    public let saleDate: Date?
    
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
        
        items = try container.decodeIfPresent([SalesItemResponse].self, forKey: .items)
        
        let dateString =
            try container.decodeIfPresent(String.self, forKey: .datetimeCreated)
            ?? container.decodeIfPresent(String.self, forKey: .saleDateAlt)
        
        if let dateString {
            saleDate = ISO8601DateFormatter().date(from: dateString)
        } else {
            saleDate = nil
        }
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
        try container.encodeIfPresent(items, forKey: .items)
        
        if let saleDate {
            let dateString = ISO8601DateFormatter().string(from: saleDate)
            try container.encode(dateString, forKey: .datetimeCreated)
        }
    }
}

public struct SalesItemResponse: Codable {
    public let id: Int
    public let product: IDNamePairInt?
    public let quantity: Double?
    public let unitPrice: Double?
    public let totalPrice: Double?
}
