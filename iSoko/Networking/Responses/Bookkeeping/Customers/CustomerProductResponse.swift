//
//  CustomerProductResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

// MARK: - Product Response

public struct CustomerProductResponse: Codable {
    public let product: IDNamePairInt
    public let quantity: Int?
    public let unitPrice: Double?
    public let totalPrice: Double?
    
    public let id: Int?
    public let name: String?
    public let price: Double?
    public let qty: Int?
    public let description: String?
}
