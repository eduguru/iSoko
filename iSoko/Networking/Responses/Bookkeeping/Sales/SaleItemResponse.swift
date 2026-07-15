//
//  SaleItemResponse.swift
//  
//
//  Created by Edwin Weru on 15/07/2026.
//


public struct SaleItemResponse: Codable {
    public let id: Int
    public let product: IDNamePairInt?
    public let quantity: Double?
    public let unitPrice: Int?
    public let totalPrice: Double?
}
