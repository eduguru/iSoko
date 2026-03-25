//
//  ExpenseResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct ExpenseResponse: Codable {
    public let id: Int
    public let amount: Double?
    public let description: String?
    
    /// Supports both "datetimeCreated" and "date"
    public let createdOn: String?
    public let expenseDate: String?
    
    public let category: IDNamePairInt?
    public let paymentMethod: IDNamePairInt?
    public let supplier: IDNamePairInt?
    
    // Optional UI helper
    public let chipBgColor: (Int, Int)?
    
    // MARK: - CodingKeys for fallback keys
    private enum CodingKeys: String, CodingKey {
        case id
        case amount
        case description
        case category
        case paymentMethod
        case supplier
        
        case datetimeCreated
        case expenseDateAlt = "date"
    }
    
    // MARK: - Custom Decoder (fallback date keys)
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        category = try container.decodeIfPresent(IDNamePairInt.self, forKey: .category)
        paymentMethod = try container.decodeIfPresent(IDNamePairInt.self, forKey: .paymentMethod)
        supplier = try container.decodeIfPresent(IDNamePairInt.self, forKey: .supplier)
        
        // Fallback for date fields
        createdOn = try container.decodeIfPresent(String.self, forKey: .datetimeCreated)
        expenseDate = try container.decodeIfPresent(String.self, forKey: .expenseDateAlt)
        
        chipBgColor = nil
    }
    
    // MARK: - Encoder
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(paymentMethod, forKey: .paymentMethod)
        try container.encodeIfPresent(supplier, forKey: .supplier)
        try container.encodeIfPresent(createdOn, forKey: .datetimeCreated)
        try container.encodeIfPresent(expenseDate, forKey: .expenseDateAlt)
    }
}
