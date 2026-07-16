//
//  SaleItemResponse.swift
//  
//
//  Created by Edwin Weru on 15/07/2026.
//

public struct SaleItemResponse: Codable {
    public let id: Int
    public let product: IDNamePairInt?
    public let sale: IDNamePairInt?
    public let quantity: Int?
    public let unitPrice: Int?
    public let amount: Double?
}
