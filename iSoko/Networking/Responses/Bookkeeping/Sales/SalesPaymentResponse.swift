//
//  SalesPaymentResponse.swift
//
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct SalesPaymentResponse: Codable {
    public let id: Int
    public let paymentDate: String?
    public let paymentAmount: Double?
    
    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case id
        
        case datetimeCreated
        case paymentDateAlt = "payment_date"
        
        case amount
        case paymentAmountAlt = "payment_amount"
    }
    
    // MARK: - Decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        
        paymentDate =
        try container.decodeIfPresent(String.self, forKey: .datetimeCreated)
        ?? container.decodeIfPresent(String.self, forKey: .paymentDateAlt)
        
        paymentAmount =
        try container.decodeIfPresent(Double.self, forKey: .amount)
        ?? container.decodeIfPresent(Double.self, forKey: .paymentAmountAlt)
    }
    
    // MARK: - Encoder
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        
        // Choose canonical keys when encoding
        try container.encodeIfPresent(paymentDate, forKey: .datetimeCreated)
        try container.encodeIfPresent(paymentAmount, forKey: .amount)
    }
}
